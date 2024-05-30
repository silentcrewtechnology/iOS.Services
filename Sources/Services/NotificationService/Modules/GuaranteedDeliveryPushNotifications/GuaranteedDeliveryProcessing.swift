//
//  GuaranteedDeliveryProcessing.swift
//  NotificationServiceExtension
//
//  Created by Oleg Pustoshkin on 18.09.2020.
//  Copyright © 2020 ps. All rights reserved.
//

import Foundation
import UserNotifications

public final class GuaranteedDeliveryProcessing: PushNotificationProcessingProtocol {
    
    // MARK: - Private properties
    
    // Full url "http://testbankok.akbars.ru/api/notifications/confirm?operationToken=operationTokenString"
    private let operationTokenServer = "http://testbankok.akbars.ru/" // NetworkConstants.serverUrl
    private let operationTokenPath = "api/notifications/confirm"
    private let operationTokenQueryParameter = "operationToken"
    
    // MARK: - Methods
    
    public func processPushNotification(mutableNotificationContent: UNMutableNotificationContent) -> Bool {
        if let operationToken = mutableNotificationContent.userInfo["operationToken"] as? String {
            #if !DEBUG
            debugPrint(
                "PushNotificationsLog \(String(describing: self))",
                "operationToken = \(operationToken) Type = \(type(of: operationToken))" )
            #endif

            // Вот это можно удалить, но рекомендую оставить, будет сильно проще тестить
            //mutableNotificationContent.title = "\(mutableNotificationContent.title) [\(operationToken)]"
            //mutableNotificationContent.body = "\(mutableNotificationContent.body) [\(operationToken)]"

            sendOperationTokenToServer(operationToken: operationToken)
        } else {
            #if !DEBUG
            debugPrint("PushNotificationsLog \(String(describing: self))", "ERROR - Cant get operation token" )
            #endif

            // Вот это можно удалить, но рекомендую оставить, будет сильно проще тестить
            //mutableNotificationContent.title = "\(mutableNotificationContent.title) [operation_token_not_sent]"
            //mutableNotificationContent.body = "\(mutableNotificationContent.body) [operation_token_not_sent]"
        }
        
        return true // Продолжаем работу работу
    }
    
    // MARK: - Private methods
    
    private func sendOperationTokenToServer(operationToken: String) {
        let operationTokenPostUrl = operationTokenServer + operationTokenPath + "?" + operationTokenQueryParameter + "=" + operationToken
        
        guard let urlFromString = URL(string: operationTokenPostUrl) else {
            return // Продолжаем обработку
        }
        var urlRequest = URLRequest(url: urlFromString)
        urlRequest.httpMethod = "POST"
        
        let currentClassDescription = String(describing: self) // Описание "данного класса"

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                debugPrint("PushNotificationsLog \(currentClassDescription)", "Networking error - ", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                debugPrint("PushNotificationsLog \(currentClassDescription)", "statusCode should be 2xx, but is \(response.statusCode)")
                debugPrint("PushNotificationsLog \(currentClassDescription)", "response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            debugPrint(
                "PushNotificationsLog \(currentClassDescription)",
                "operationToken = \(operationToken)",
                "responseString = \(responseString ?? "Nil")")
        }

        task.resume()
    }
}
