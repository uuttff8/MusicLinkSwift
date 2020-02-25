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
        
    }
    
    func getHistory(completion: ((String, String) -> ())) {
        // TODO: fetch data from CoreData
        let context = self.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            for data in result {
                let labelText = data.value(forKey: "name") as! String
                let imageText = data.value(forKey: "image") as! String
                
                print("\n new value from core data:" + HistoryCellModel(label: labelText, image: imageText).description + "\n")
                
                completion(labelText, imageText)
            }
        } catch {
            print("Failed")
        }
    }
}
