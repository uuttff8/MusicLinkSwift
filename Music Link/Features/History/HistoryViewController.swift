//
//  HistoryViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var presenter = HistoryPresenter()
    @IBOutlet weak var tableView: UITableView!
    
    var items: Array<HistoryCellModel> = []
    private let refreshControl = UIRefreshControl()
    
    fileprivate func unwrapDataFromCoreData(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            CoreDataManager.shared.getHistory { (models) in
                print("---")
                print(models)
                self.items = models.uniques
                completion()
            }
        }
    }
    
    @objc func refreshAllVc() {
        unwrapDataFromCoreData { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        refreshControl.addTarget(self, action: #selector(refreshAllVc), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAllVc()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = items.count
        
        if count == 0 {
            tableView.setEmptyMessage("Failed to load history\nor the list is empty")
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTableViewCell.self)) as! HistoryTableViewCell
        cell.bind(data: items[indexPath.row])
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
                    style: .destructive,
                    title: "Delete",
                    handler: { (action, view, bool) in
                        CoreDataManager.shared.deleteConcreteSong(label: self.items[indexPath.row].label)
                        self.items.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
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
