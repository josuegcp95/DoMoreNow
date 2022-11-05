//
//  PersistenceManager.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let tasks = "tasks"
    }
    
    static func retrieveTasks(completed: @escaping (Result<[Action], DMError>) -> Void) {
        guard let tasksData = defaults.object(forKey: Keys.tasks) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let tasks = try decoder.decode([Action].self, from: tasksData)
            completed(.success(tasks))
        } catch  {
            completed(.failure(.unableToRetrieve))
        }
    }
    
    static func saveTasks(tasks: [Action], completed: @escaping (DMError?) -> Void) {
        do {
            let encoder = JSONEncoder()
            let encodedTasks = try encoder.encode(tasks)
            defaults.set(encodedTasks, forKey: Keys.tasks)
            completed(nil)
    
        } catch  {
            completed(.unableToSave)
        }
    }
}
