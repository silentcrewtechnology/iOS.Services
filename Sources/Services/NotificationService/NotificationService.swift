//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Oleg Pustoshkin on 17.09.2020.
//  Copyright © 2020 ps. All rights reserved.
//

// MARK: Краткое описания сервиса. Тут слово сервис используется в контексте *NIX сервиса (httpd, ftpd и т.д.)
/*
 ВНИМАНИЕ: Нельзя ставить break point тут и в основном приложение на отслеживание PushNotification, это приводит uncatcheble exception.
 Скорее всего переходит это из за переключение м/д основным приложением и сервисом, при этом XCode путается в захваченных break points
*/
/*
 Для того чтобы сервис обрабатывал пуш запрос (пуш попадал в сервис) необходимо чтобы у запроса был флаг
 "mutable-content" = 1;
 Флаг "content-available" = 1; (стоит именно в 1), может помешать (по комменатриям из манов и интернета) попаданию пуша в сервис
 Правильный формат выглядит примерно так
{
 aps =     {
     alert =         {
         body = "Test push";
     };
     badge = 0;
     "content-available" = 0;
     "mutable-content" = 1;
 };
 operationToken = "b0ea76e0-a36b-4417-8566-bbe28f11da78";
}
*/
/*
 NotificationService для перехвата и изменения Push уведомлений
 Полезные ссылки по работе с ним
 https://www.raywenderlich.com/8277640-push-notifications-tutorial-for-ios-rich-push-notifications
 https://habr.com/ru/company/oleg-bunin/blog/462507/
*/

import UserNotifications
// Для подключения модулей прописать в podfile привила для данного тарегта
// Пример:
//target :NotificationServiceExtension do
//    pod 'ISO8601DateFormatter', '= 0.8'
//
//    pod 'Moya', '= 13.0.1'
//end

class NotificationService: UNNotificationServiceExtension {
    
    // MARK: - Properties
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    // MARK: Добавлять обработчики запросов тут
    
    private var processingChainList: [PushNotificationProcessingProtocol] = {
        var processingNotificationList: [PushNotificationProcessingProtocol] = []
        
        #if DEBUG
        processingNotificationList.append(LogPushNotifications(logPrefixString: "-Head of chain-"))
        #endif
        processingNotificationList.append(GuaranteedDeliveryProcessing())
        #if DEBUG
        // Логгер будет полезен чтобы смотреть как изменился контент после обработки (если после обработки он у нас изменяется)
        processingNotificationList.append(LogPushNotifications(logPrefixString: "-END of chain-"))
        #endif

        
        return processingNotificationList
    }()
    
    // MARK: - Methods

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        #if !DEBUG
            debugPrint("PushNotificationsLog didReceive Start", #function, #line)
        #endif
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            for processObject in processingChainList {
                if !processObject.processPushNotification(mutableNotificationContent: bestAttemptContent) {
                    break // Выкинул false, далее не выполняем обработку
                }
            }

            contentHandler(bestAttemptContent)
        }
        #if !DEBUG
            debugPrint("PushNotificationsLog didReceive end", #function, #line)
        #endif
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
