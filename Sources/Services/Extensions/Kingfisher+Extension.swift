import Foundation
import Kingfisher

extension KingfisherManager {
    
    /// Содержит актуальный SessionToken
    public static let authorizedDefault: KingfisherManager = .init(
        downloader: .init(name: "authorized-default"),
        cache: .default
    )
    
    /// Добавляет `SessionToken` в хэдеры при запросе картинок
    public func setSessionToken(_ sessionToken: String?) {
        downloader.sessionConfiguration.httpAdditionalHeaders = [
            "SessionToken": sessionToken as Any
        ]
    }
}
