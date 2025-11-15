//
//  RemoveTextService.swift
//
//
//  Created by user on 25.04.2024.
//

import Foundation

public struct RemoveTextService {
    
    // MARK: - Methods

    public func remove(in text: String?, count: Int) -> String {
        guard var text = text else { return "" }
        
        if text.count > count {
            let countRemove = (text.count - count)
            text.removeLast(countRemove)
            text.append("...")
            
            return text
        } else {
            return text
        }
    }
}
