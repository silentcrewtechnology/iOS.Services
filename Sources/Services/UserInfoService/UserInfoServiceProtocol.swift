//
//  UserInfoServiceProtocol.swift
//
//
//  Created by user on 16.09.2024.
//

import Foundation

public protocol UserInfoServiceProtocol {
    
    func getUserInfo(
        success: @escaping (UserInfo) -> Void,
        failure: @escaping (NSError) -> Void
    )
    
    func getStoredUserInfo(
        completion: @escaping (UserInfo?) -> Void
    )
}
