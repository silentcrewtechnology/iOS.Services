//
//  UserInfoRepository.swift
//
//
//  Created by user on 16.09.2024.
//

import UIKit
import NetworkService

public protocol UserInfoRepository {

    func getUserInfo(
        success: @escaping (UserInfo) -> Void,
        failure: @escaping (NSError) -> Void
    )
}
