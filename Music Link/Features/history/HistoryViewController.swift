//
//  HistoryViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

struct HistoryCellModel: Equatable {
    let label: String!
    let image: String!
}

extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var presenter = HistoryPresenter()
    @IBOutlet weak var tableView: UITableView!
    
    var items: Array<HistoryCellModel> = []
    private let refreshControl = UIRefreshControl()
    
    fileprivate func unwrapDataFromCoreData() {
        // TODO: fetch data from CoreData
        let context = CoreDataManager.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print("\n new value from core data:" + String(data.value(forKey: "name") as! String) + "\n")
                
                let labelText = data.value(forKey: "name") as! String
                let imageText = data.value(forKey: "image") as! String
                
                items.insert(.init(label: labelText, image: imageText), at: 0)
                
                // Why i don't use Array(Set(items))?
                // answer: that method can randomly sort the array
                items = items.removeDuplicates()
                print(items)
            }
        } catch {
            print("Failed")
        }
    }
    
    @objc func refreshAllVc() {
        items.removeAll()
        unwrapDataFromCoreData()
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        refreshControl.addTarget(self, action: #selector(refreshAllVc), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unwrapDataFromCoreData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = items.count
        
        if(count == 0) {
            tableView.setEmptyMessage("Не удалось загрузить историю\nили список пуст")
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseId) as! HistoryTableViewCell
        cell.songLabel.text = items[indexPath.item].label
        Imager.shared.loadImage(into: cell.songImageView, link: items[indexPath.item].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // TOOD(uuttff8): make delete button action
    /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, bool) in
            
            let context = CoreDataManager.context
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
            request.returnsObjectsAsFaults = false
            
            do {
                var result = try context.fetch(request)
                print("\(result[indexPath.item]) is deleted")
            } catch {
                
            }
            
            self.items.removeAll()
            self.unwrapDataFromCoreData()
            tableView.reloadData()
        })])
        
        return deleteButton
    }
 */
}

extension HistoryViewController: HistoryView {
    
    func showError(title: String, message: String?) {
        let alert = UIAlertController.createOkAlert(title: title, message: message)
        self.present(alert, animated: true)
    }
    
}
