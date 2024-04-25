//
//  CoreDataService.swift
//  
//
//  Created by user on 24.04.2024.
//

import UIKit
import CoreData

struct CoreDataService {
    
    // MARK: - Properties
    
    enum Predicate {
        case key(Key, String)
        
        func create() -> NSPredicate {
            switch self {
            case .key(let key, let name):
                return NSPredicate(format: "%@==\(key.rawValue)", name)
            }
        }
    }
    
    enum Key: String, CaseIterable {
        case productID
    }
    
    // MARK: - Methods
    
    func fetchName<T: NSManagedObject>(object: T, predicate: Predicate) -> T? {
        let fetchRequest: NSFetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate.create()
        
        do {
            let result = try PersistentService.viewContext.fetch(fetchRequest).first as? T
            
            return result
        } catch {
            print(error.localizedDescription, "Ошибка получения по имени объекта \(object) из CoreData")
            
            return nil
        }
    }
    
    func fetch<T: NSManagedObject>(object: T.Type) -> [T]? {
        do {
            let result = try PersistentService.viewContext.fetch(T.fetchRequest()) as? [T]
            
            return result
        } catch {
            print(error.localizedDescription, "Ошибка получения массива объектов \(object) из CoreData")
            
            return nil
        }
    }
    
    func create<T: NSManagedObject>(object: T.Type) -> T {
        let object = T(context: PersistentService.viewContext)
        PersistentService.saveContext()
        
        return object
    }
    
    func delete(object: NSManagedObject?) {
        guard let object = object else { return }
        
        PersistentService.viewContext.delete(object)
    }
    
    func save() {
        PersistentService.saveContext()
    }
}
