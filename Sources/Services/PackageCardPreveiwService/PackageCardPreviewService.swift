//
//  PackageCardPreviewService.swift
//
//
//  Created by user on 25.04.2024.
//

import UIKit
import Kingfisher

public enum PackageCardPreviewService {
    
    // MARK: - Methods
    
    public static func loadCardIcon(
        url: URL,
        completion: @escaping (UIImage) -> Void
    ) {
        KF.url(url)
          .onSuccess { result in
              completion(result.image)
          }
    }
    
    public static func paymentSystemIcon(paymentSystem: PackageCardPreviewPaymentSystem) -> UIImage {
        switch paymentSystem {
        case .unknown:
            return .init()
        case .visa:
//            return Asset.cardLogoVisaBlack216х144.image
//                .tinted(with: .contentActionOn)
            return UIImage()
        case .masterCard:
//            return Asset.cardLogoMasterCardWhite216х144.image
            return UIImage()
        case .maestro:
            return .init()
        case .mir:
//            return Asset.cardLogoMirBlack216х144.image
//                .tinted(with: .contentActionOn)
            return UIImage()
        }
    }
}
