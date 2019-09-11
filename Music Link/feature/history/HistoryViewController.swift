//
//  HistoryViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: BaseViewController {
    
    private var presenter = HistoryPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: fetch data from CoreData
        // example: print  values from History entities for name attribute
        
        let context = CoreDataManager.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
            
            
        } catch {
            
            print("Failed")
        }
 
        
    }
}

extension HistoryViewController: HistoryView {
    func showError(text: String) {
        let alert = UIAlertController.createOkAlert(text: text)
        self.present(alert, animated: true)
    }
    
    func showLoading(isLoading: Bool) {
        
    }
    
    
}
