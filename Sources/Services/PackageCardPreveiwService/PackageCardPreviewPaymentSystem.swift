//
//  PackageCardPreviewPaymentSystem.swift
//
//
//  Created by user on 25.04.2024.
//

import Foundation

public enum PackageCardPreviewPaymentSystem: Int, Codable {
    case unknown
    case visa
    case masterCard
    case maestro
    case mir
    
    public init(from decoder: Decoder) throws {
        self = try PackageCardPreviewPaymentSystem(
            rawValue: decoder.singleValueContainer().decode(RawValue.self)
        ) ?? .unknown
    }
}
