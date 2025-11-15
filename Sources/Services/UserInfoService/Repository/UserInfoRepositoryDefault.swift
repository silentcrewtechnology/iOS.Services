//
//  UserInfoRepositoryDefault.swift
//  
//
//  Created by user on 16.09.2024.
//

import Alamofire
import UIKit
import NetworkService

public struct UserInfoRepositoryDefault: UserInfoRepository {
    
    // MARK: - Private properties
    
    private let networkService: NetworkService
    
    // MARK: - Life cycle
    
    public init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    public func getUserInfo(
        success: @escaping (UserInfo) -> Void,
        failure: @escaping (NSError) -> Void
    ) {
        networkService.request(
            endpoint: "users/user_info",
            success: success,
            failure: { error in
                failure(error as NSError)
            }
        )
    }
}
