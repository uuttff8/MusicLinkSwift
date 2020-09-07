//
//  CoreDataManager.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = { appDelegate.persistentContainer.viewContext }()
    
    static func tryToSave(with context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getHistory(completion: ((String, String) -> ())) {
        let context = self.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            for data in result {
                let labelText = data.value(forKey: "name") as! String
                let imageText = data.value(forKey: "image") as! String
                
                completion(labelText, imageText)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteConcreteSong(label: String) {
        let context = CoreDataManager.shared.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "name = %@", label)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let test = try context.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            CoreDataManager.tryToSave(with: context)
        } catch let error {
            print(error)
        }

    }
}
