import Foundation
import Kingfisher

extension ImageDownloader {
    
    private static var cachedAuthorizedDefault = ImageDownloader(name: "authorized-default")
    
    /// Содержит актуальный SessionToken
    static var authorizedDefault: ImageDownloader {
        let storage = AppStorageService()
        var configuration = cachedAuthorizedDefault.sessionConfiguration
        configuration.httpAdditionalHeaders = [
            "SessionToken": storage.sessionToken as Any
        ]
        cachedAuthorizedDefault.sessionConfiguration = configuration
        
        return cachedAuthorizedDefault
    }
}

public extension KingfisherManager {
    
    private static var cachedAuthorizedDefault = KingfisherManager(downloader: .authorizedDefault, cache: .default)
    
    /// Содержит актуальный SessionToken
    static var authorizedDefault: KingfisherManager {
        cachedAuthorizedDefault.downloader = .authorizedDefault
        return cachedAuthorizedDefault
    }
}
