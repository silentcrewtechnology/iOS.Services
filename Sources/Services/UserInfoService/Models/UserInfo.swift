//
//  UserInfo.swift
//
//
//  Created by user on 16.09.2024.
//

import Foundation

public struct UserInfo: Decodable {
    public var uid: String?
    public var firstName: String?
    public var lastName: String?
    public var middleName: String?
    public var displayName: String?
    public var gender: String?
    public var pictureUrl: String?
    public var originalPictureUrl: String?
    public var mobilePhone: String?
    public var socialNetworks: [String]?
    public var status: String?
    public var bankokCardStatus: BankokCardStatus?
    public var akbarsId: String?
    public var defaultContractId: String?
    
    enum CodingKeys: String, CodingKey {
        case uid = "Uid"
        case firstName = "FirstName"
        case lastName = "LastName"
        case middleName = "MiddleName"
        case displayName = "DisplayName"
        case gender = "Gender"
        case pictureUrl = "PictureUrl"
        case originalPictureUrl = "OriginalPictureUrl"
        case mobilePhone = "MobilePhone"
        case socialNetworks = "SocialNetworks"
        case status = "Status"
        case bankokCardStatus = "BankokCardStatus"
        case akbarsId = "AkbarsId"
        case defaultContractId = "DefaultContractId"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decodeIfPresent(String.self, forKey: .uid)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.pictureUrl = try container.decodeIfPresent(String.self, forKey: .pictureUrl)
        self.originalPictureUrl = try container.decodeIfPresent(String.self, forKey: .originalPictureUrl)
        self.mobilePhone = try container.decodeIfPresent(String.self, forKey: .mobilePhone)
        self.socialNetworks = try container.decodeIfPresent([String].self, forKey: .socialNetworks)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.bankokCardStatus = try container.decodeIfPresent(BankokCardStatus.self, forKey: .bankokCardStatus)
        self.akbarsId = try container.decodeIfPresent(String.self, forKey: .akbarsId)
        self.defaultContractId = try container.decodeIfPresent(String.self, forKey: .defaultContractId)
    }
    
    public init(
        firstName: String?,
        pictureUrl: String?
    ) {
        self.firstName = firstName
        self.pictureUrl = pictureUrl
    }
}

public enum BankokCardStatus: String, Decodable {
    case undefined = "Undefined"
    case inProgress = "InProgress" // Карта в процессе выпуска
    case released = "Released" // Карта выпущена
    case blockedForever = "BlockedForever" // Карта заблокирована навсегда
    case notIssued = "NotIssued" // Карта не выпущена
}
