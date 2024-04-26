//
//  DelayTaskService.swift
//  
//
//  Created by user on 25.04.2024.
//

import Foundation

// Сервис для отмены предыдущего действия
final class DelayTaskService {
    
    // MARK: - Private properties
    
    private var timer: Timer?
    
    // MARK: - Properties
  
    var execute: (() -> Void)?

    // MARK: - Methods

    func executeAfter(seconds: Double) {
        cancelDelete()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] _ in
            self?.execute?()
        })
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    // MARK: - Private properties

    private func cancelDelete() {
        timer?.invalidate()
        timer = nil
    }
}
