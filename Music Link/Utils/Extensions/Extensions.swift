//
//  Extensions.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension UIApplication {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

extension UIAlertController {
    class func createOkAlert(title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

extension UITableView {
    func insertRowsAndUpdate(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, _ changes: (() -> Void)) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                changes()
                insertRows(at: indexPaths, with: animation)
            })
        } else {
            beginUpdates()
            changes()
            insertRows(at: indexPaths, with: animation)
            endUpdates()
        }
    }
    
    func reloadRowsAndUpdate(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                reloadRows(at: indexPaths, with: animation)
            })
        } else {
            beginUpdates()
            reloadRows(at: indexPaths, with: animation)
            endUpdates()
        }
    }
    
    func deleteRowsAndUpdate(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, _ changes: (() -> Void)) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                changes()
                deleteRows(at: indexPaths, with: animation)
            })
        } else {
            beginUpdates()
            changes()
            deleteRows(at: indexPaths, with: animation)
            endUpdates()
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.separatorStyle = .none
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}

