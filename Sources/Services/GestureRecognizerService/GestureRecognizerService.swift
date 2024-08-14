//
//  GestureRecognizerService.swift
//
//
//  Created by user on 14.08.2024.
//

import UIKit

public final class GestureRecognizerService {
    
    // MARK: - Private properties
    
    private var textProvider: (() -> String?)?
    private var menuTitle: String?
    
    // MARK: - Methods
    
    public func createRecognizerForCopy(
        numberOfTapsRequired: Int = 1,
        minimumPressDuration: CGFloat = 0.3,
        cancelsTouchesInView: Bool = false,
        menuTitle: String? = nil,
        textProvider: @escaping () -> String?
    ) -> UILongPressGestureRecognizer {
        self.textProvider = textProvider
        self.menuTitle = menuTitle
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.numberOfTapsRequired = numberOfTapsRequired
        longPressRecognizer.minimumPressDuration = minimumPressDuration
        longPressRecognizer.cancelsTouchesInView = cancelsTouchesInView
        
        return longPressRecognizer
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.view?.becomeFirstResponder()
            
            let copyItem = UIMenuItem(title: menuTitle ?? "", action: #selector(copyText))
            UIMenuController.shared.menuItems?.removeAll()
            UIMenuController.shared.menuItems = [copyItem]
            UIMenuController.shared.update()
        
            let location = gesture.location(in: gesture.view)
            let menuLocation = CGRect(
                x: location.x,
                y: location.y,
                width: .zero,
                height: .zero
            )
            UIMenuController.shared.showMenu(from: gesture.view!, rect: menuLocation)
        }
    }
    
    @objc private func copyText() {
        UIPasteboard.general.string = textProvider?()
    }
}
