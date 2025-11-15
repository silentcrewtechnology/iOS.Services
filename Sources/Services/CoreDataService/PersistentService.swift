//
//  PersistentService.swift
//  
//
//  Created by user on 24.04.2024.
//

import Foundation
import CoreData

struct PersistentService {
    
    // MARK: - Private properties
    
    private static let persistentContainerName = "BankOK"
    
    // MARK: - Properties
    
    // Контейнер
    static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: persistentContainerName)
        persistentContainer.loadPersistentStores(completionHandler: {(_, error) in
            if let error = error as NSError? {
                print("PersistentService loadPersistentStores error \(error), \(error.userInfo)")
            }
        })
        
        return persistentContainer
    }()
    
    // Контекст в котором сохраняем данные
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Life cycle

    private init() {}
    
    // Сохранение в контейнер
    static func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                let nserror = error as NSError
                print("PersistentService saveContext error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Удаление из контейнера
    static func deleteContext(object: NSManagedObject?) {
        guard let object = object else { return }
        
        viewContext.delete(object)
        saveContext()
    }
}
