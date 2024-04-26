//
//  PushNotificationProcessingProtocol.swift
//  NotificationServiceExtension
//
//  Created by Oleg Pustoshkin on 18.09.2020.
//  Copyright © 2020 ps. All rights reserved.
//

import Foundation
import UserNotifications

// Протокол для обработки PushNotification.
// Чтоб не плодить код в NotificationService создал chain of responsibility
protocol PushNotificationProcessingProtocol: AnyObject {
    // При возвращение false прекращаем обработку
    /* Example:
     *  mutableNotificationContent.title = "\(mutableNotificationContent.title) [modified]"
     *  mutableNotificationContent.body = "\(mutableNotificationContent.body) [modified]"
     */
    func processPushNotification(mutableNotificationContent: UNMutableNotificationContent) -> Bool
}
