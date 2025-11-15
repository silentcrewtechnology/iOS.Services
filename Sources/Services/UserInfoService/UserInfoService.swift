//
//  UserInfoService.swift
//
//
//  Created by user on 16.09.2024.
//

import NetworkService
import Foundation

public final class UserInfoService: UserInfoServiceProtocol {
    
    // MARK: - Private properties
    
    private let repository: UserInfoRepository
    private let storageService: AppStorageService
    
    // MARK: - Life cycle
    
    public init(
        repository: UserInfoRepositoryDefault,
        storageService: AppStorageService
    ) {
        self.repository = repository
        self.storageService = storageService
    }
    
    // MARK: - Methods
    
    public func getUserInfo(
        success: @escaping (UserInfo) -> Void, 
        failure: @escaping (NSError) -> Void
    ) {
        repository.getUserInfo(
            success: { [weak self] userInfo in
                self?.storageService.userFirstName = userInfo.firstName
                self?.storageService.userPictureURL = userInfo.pictureUrl
                
                success(userInfo)
            },
            failure: failure
        )
    }
    
    public func getStoredUserInfo(
        completion: @escaping (UserInfo?) -> Void
    ) {
        let storedUserFirstName = storageService.userFirstName
        if storedUserFirstName != nil {
            completion(
                .init(
                    firstName: storedUserFirstName,
                    pictureUrl: storageService.userPictureURL
                )
            )
        } else {
            completion(nil)
        }
    }
}
