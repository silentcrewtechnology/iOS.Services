//
//  KeyboardService.swift
//  
//
//  Created by user on 24.04.2024.
//

import UIKit
import Combine

public struct KeyboardService {
    
    // MARK: - Properties
    
    var showKeyboard = PassthroughSubject<CGFloat, Never>()
    var dismissKeyboard = PassthroughSubject<CGFloat, Never>()
    
    // MARK: - Life cycle
    
    public init() {
        setupNotification()
    }
    
    // MARK: - Private methods
    
    private func setupNotification(){
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { notification in
            self.animationContentKeyboard(
                notification: notification,
                show: true
            )
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { notification in
            self.animationContentKeyboard(
                notification: notification,
                show: false
            )
        }
    }
    
    private func animationContentKeyboard(notification: Notification, show: Bool){
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let currentWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
        
        guard let currentWindow = currentWindow else { return }
        
        let heightAnimation = (keyboardFrame.height - currentWindow.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.5) {
            switch show {
            case true:
                self.showKeyboard.send(heightAnimation)
            case false:
                self.dismissKeyboard.send(heightAnimation)
            }
        }
    }
}
