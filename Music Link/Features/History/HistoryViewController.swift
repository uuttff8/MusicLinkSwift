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
    
    var description: String {
        return
            "Name: \(String(describing: label))\n" +
        "image: \(String(describing: image))\n"
    }
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var presenter = HistoryPresenter()
    @IBOutlet weak var tableView: UITableView!
    
    var items: Array<HistoryCellModel> = []
    private let refreshControl = UIRefreshControl()
    
    fileprivate func unwrapDataFromCoreData() {
        DispatchQueue.main.async {
            CoreDataManager.shared.getHistory { (labelText, imageText) in
                self.items.append(HistoryCellModel(label: labelText, image: imageText))
                self.items = self.items.removeDuplicates()
            }
        }
    }
    
    @objc func refreshAllVc() {
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
            tableView.setEmptyMessage("Failed to load history\nor the list is empty")
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTableViewCell.self)) as! HistoryTableViewCell
        cell.songLabel.text = items[indexPath.item].label
        
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        Imager.shared.loadImage(into: cell.songImageView, link: items[indexPath.item].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // TOOD(uuttff8): make delete button action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UISwipeActionsConfiguration(
            actions:
            [
                UIContextualAction(
                    style: .normal,
                    title: "Delete",
                    handler: { (action, view, bool) in
                        
                        let context = CoreDataManager.shared.context
                        
                        let label = self.items[indexPath.row].label ?? ""
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
                        fetchRequest.predicate = NSPredicate(format: "name = %@", label)
                        fetchRequest.returnsObjectsAsFaults = false
                        
                        
                        
                        do {
                            let test = try context.fetch(fetchRequest)
                            
                            let objectToDelete = test[0] as! NSManagedObject
                            context.delete(objectToDelete)
                            
                            
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                            
                        } catch let error as NSError {
                            debugPrint(error)
                        }
                    })
            ]
        )
        
        return deleteButton
    }
}

extension HistoryViewController: HistoryView {
    
    func showError(title: String, message: String?) {
        let alert = UIAlertController.createOkAlert(title: title, message: message)
        self.present(alert, animated: true)
    }
    
}
