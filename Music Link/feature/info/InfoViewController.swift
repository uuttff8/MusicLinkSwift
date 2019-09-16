//
//  InfoViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var links: LinksResponse!
    
    private var presenter = InfoPresenter()
    
    // MARK: - Controller initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 640.0; // set to whatever your "average" cell height is
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_horiz"), style: .done, target: self, action: #selector(showAlertWithAllLinks))
        
        // Please refer to viewWillAppear to know when collection view cells is updated
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Func
    
    @objc func showAlertWithAllLinks() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let copyAllLinksAction = UIAlertAction(title: "Copy all links in pasteboard", style: .default) { (_) in
            UIPasteboard.general.string = self.links.pageUrl
            print("\(self.links.pageUrl) is copied")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(copyAllLinksAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        print("alert called")
    }
    

}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.reuseId) as! InfoTableViewCell
        cell.bind(data: links)
        cell.links = links
        cell.baseVC = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 640
    }
    
}

extension InfoViewController: InfoView {
    func showError(title: String, message: String?) {
        let alert = UIAlertController.createOkAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
}

