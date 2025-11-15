//
//  LogPushNotifications.swift
//  NotificationServiceExtension
//
//  Created by Oleg Pustoshkin on 18.09.2020.
//  Copyright © 2020 ps. All rights reserved.
//

import Foundation
import UserNotifications

public final class LogPushNotifications: PushNotificationProcessingProtocol {
    
    // MARK: - Private properties
    
    private let logPrefixString: String
    private let dateFormatterService = DateFormatterService()
    
    // MARK: - Life cycle
    
    public init(logPrefixString: String) {
        self.logPrefixString = logPrefixString
    }
    
    // MARK: - Methods
    
    public func processPushNotification(mutableNotificationContent: UNMutableNotificationContent) -> Bool {
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) Log Start",
            #function,
            #line)
        // The title of the notification.
        // Use -[NSString localizedUserNotificationStringForKey:arguments:]
        // to provide a string that will be localized at the time that the notification is presented.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.title",
            mutableNotificationContent.title)
        // The subtitle of the notification.
        // Use -[NSString localizedUserNotificationStringForKey:arguments:]
        // to provide a string that will be localized at the time that the notification is presented.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.subtitle",
            mutableNotificationContent.subtitle)
        // Apps can set the userInfo for locally scheduled notification requests.
        // The contents of the push payload will be set as the userInfo for remote notifications.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.body",
            mutableNotificationContent.body)
        // The application badge number. nil means no change. 0 to hide.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.badge",
            mutableNotificationContent.badge ?? "Nil")
        // The identifier for a registered UNNotificationCategory that will be used
        // to determine the appropriate actions to display for the notification.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.categoryIdentifier",
            mutableNotificationContent.categoryIdentifier)
        // The launch image that will be used when the app is opened from the notification.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.launchImageName",
            mutableNotificationContent.launchImageName)
        // The sound that will be played for the notification.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.sound",
            mutableNotificationContent.sound ?? "Nil")
        // The unique identifier for the thread or conversation related to this notification request.
        // It will be used to visually group notifications together.
        debugPrint(
            generateDateStamp(),
            "PushNotificationsLog \(logPrefixString) bestAttemptContent.launchImageName",
            mutableNotificationContent.threadIdentifier)
        
        // Apps can set the userInfo for locally scheduled notification requests.
        // The contents of the push payload will be set as the userInfo for remote notifications.
        dump(
            mutableNotificationContent.userInfo,
            name: "\(generateDateStamp()) PushNotificationsLog \(logPrefixString) mutableNotificationContent.userInfo")
        // Optional array of attachments.
        dump(
            mutableNotificationContent.attachments,
            name: "\(generateDateStamp()) PushNotificationsLog \(logPrefixString) mutableNotificationContent.attachments")
        debugPrint("PushNotificationsLog Log End", #function, #line)
    
        return true // Продолжаем работу работу
    }
    
    // MARK: - Private methods
    
    private func generateDateStamp() -> String {
        return dateFormatterService.makeStringFromDate(date: Date(), format: .yyyyMMddHHmmss)
    }
}
