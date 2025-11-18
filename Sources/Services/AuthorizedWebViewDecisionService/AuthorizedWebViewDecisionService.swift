//
//  AuthorizedWebViewDecisionService.swift
//
//
//  Created by user on 25.04.2024.
//

import Foundation
import WebKit

/// Хэлпер, помогает принять решение о показе/отмене показа страницы в webView
public final class AuthorizedWebViewDecisionService {
    
    // MARK: - Private properties

    private let startUrl: URL?
    
    // MARK: - Properties
    
    public weak var webViewCookieStore: WKHTTPCookieStore?
    
    // MARK: - Life cycle

    public init(startUrl: URL?) {
        self.startUrl = startUrl
    }
    
    // MARK: - Methods

    public func makeDecisionAndLoadDocumentIfNeeded(
        response: URLResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void,
        successDownloadCompletion: @escaping (URL) -> Void,
        downloadFileErrorCompletion: @escaping (URL?) -> Void,
        responseStatusErrorCompletion: (URL?) -> Void
    ) {
        guard let response = response as? HTTPURLResponse, let url = response.url else {
            decisionHandler(.allow)
            return
        }

        // Нужно отследить ошибку и показать error c с предложением перезагрузить страницу
        let is404Error = response.statusCode >= 400 && response.statusCode < 500
        let is500Error = response.statusCode >= 500 && response.statusCode < 600
        if is404Error || is500Error {
            if isDocumentDownloadUrl(absoluteUrlString: url.absoluteString) {
                downloadFileErrorCompletion(url)
            } else {
                responseStatusErrorCompletion(url)
            }
            decisionHandler(.cancel)
            
            return
        }

        // Проверка на наличие в после content-Disposition поля attached
        if let contentDisposition = response.allHeaderFields["Content-Disposition"] as? String,
           isAttachmentInContentDisposition(text: contentDisposition),
           let outputFileName = response.suggestedFilename {
            decisionHandler(.cancel)
            loadDocumentFrom(
                url: url,
                downloadFileName: outputFileName,
                successDownloadCompletion: successDownloadCompletion,
                errorCompletion: downloadFileErrorCompletion
            )
            
            return
        }

        // Проверяем Content-Type на "файловые" типы
        if let contentType = response.allHeaderFields["Content-Type"] as? String,
           Constants.contentTypeSet.contains(contentType) {
            let outputFileName = response.suggestedFilename ?? url.lastPathComponent
            decisionHandler(.cancel)
            loadDocumentFrom(
                url: url,
                downloadFileName: outputFileName,
                successDownloadCompletion: successDownloadCompletion,
                errorCompletion: downloadFileErrorCompletion
            )
            
            return
        }

        // Проверяем URL на расширение у файла
        if Constants.downloadFilesExtensionsSet.contains(url.pathExtension) {
            let outputFileName = url.lastPathComponent
            decisionHandler(.cancel)
            loadDocumentFrom(
                url: url,
                downloadFileName: outputFileName,
                successDownloadCompletion: successDownloadCompletion,
                errorCompletion: downloadFileErrorCompletion
            )
            
            return
        }

        decisionHandler(.allow)
    }

    // Решаем показывать ли активити индикатор для данного урла либо нет
    public func makeDecisionShowActivityIndicator(
        url: URL,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void,
        activityIndicatorCompletion: () -> Void
    ) {
        if isDocumentDownloadUrl(absoluteUrlString: url.absoluteString) {
            activityIndicatorCompletion()
        }

        decisionHandler(.allow)
    }

    public func loadDocumentFrom(
        url downloadUrl: URL,
        downloadFileName: String?,
        successDownloadCompletion: @escaping (URL) -> Void,
        errorCompletion: @escaping (URL?) -> Void
    ) {
        // Формируем файл
        let localFileURL: URL
        let downloadFileName = downloadFileName ?? downloadUrl.lastPathComponent
        if let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            localFileURL = cacheDirectoryUrl.appendingPathComponent(downloadFileName)
        } else {
            localFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(downloadFileName)
        }

        // Копируем куки из браузера, без них у нас не сработает скачивание файлов
        webViewCookieStore?.getAllCookies { [weak self] cookies in
            guard let self = self else { return }

            let domainName = self.startUrl?.host

            for cookie in cookies {
                var isHostNameInCookieDomain: Bool = false
                if let domainName = domainName, cookie.domain.contains(domainName) {
                    isHostNameInCookieDomain = true
                }
                
                let isAbbDomain: Bool = {
                    #if DEBUG
                    cookie.domain.contains("example.com")
                    #else
                    cookie.domain.contains("example.com")
                    #endif
                }()
                if isHostNameInCookieDomain || isAbbDomain {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }

        
        // TODO: Техдолг PCABO3-7039 - заменить urlSession на alamofire
        let session = URLSession.shared
        session.configuration.httpCookieStorage = HTTPCookieStorage.shared
        session.configuration.httpCookieAcceptPolicy = .always
        session.configuration.httpShouldSetCookies = true

        session.dataTask(with: downloadUrl) { data, response, err in
            guard let data = data, err == nil else {
                // Не скачался файл, нужно перезагрузить и вывести ошибку
                DispatchQueue.main.async {
                    errorCompletion(downloadUrl)
                }
                
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let is404Error = httpResponse.statusCode >= 400 && httpResponse.statusCode < 500
                let is500Error = httpResponse.statusCode >= 500 && httpResponse.statusCode < 600
                if is404Error || is500Error {
                    DispatchQueue.main.async {
                        errorCompletion(downloadUrl)
                    }
                    
                    return
                }
            }

            // Кладем "бинарку" в темповый файл (кэш директория) для того чтобы показать его в BOKStyledQLPreviewController
            do {
                try data.write(to: localFileURL, options: .atomic) // atomic option overwrites it if needed

                DispatchQueue.main.async {
                    successDownloadCompletion(localFileURL)
                }
            } catch {
                DispatchQueue.main.async {
                    errorCompletion(downloadUrl)
                }
                
                return
            }
        }.resume()
    }
    
    // MARK: - Private methods

    private func regExpMatchingStrings(regex: String, string: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        
        let nsString = string as NSString
        let results = regex.matches(in: string, options: [], range: NSRange(0..<nsString.length))
        
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }

    private func isAttachmentInContentDisposition(text: String) -> Bool {
        let attachmentRegexpPattern = #"(?:^|\s)attachment;"#
        let matchesResult = regExpMatchingStrings(regex: attachmentRegexpPattern, string: text)

        return !matchesResult.isEmpty
    }

    private func isDocumentDownloadUrl(absoluteUrlString: String) -> Bool {
        let documentDownloadRegexpPattern = #"/api/v1/applications/.+?/documents/"#
        let matchesResult = regExpMatchingStrings(regex: documentDownloadRegexpPattern, string: absoluteUrlString)

        return !matchesResult.isEmpty
    }
}

// MARK: - Constants

private enum Constants {
    static let downloadFilesExtensionsSet: Set<String> = [
        "pdf",
        "jpeg",
        "jpg",
        "png"
    ]

    static let contentTypeSet: Set<String> = [
        "application/pdf",
        "image/tiff",
        "image/jpeg",
        "image/jpg",
        "image/png"
    ]
}
