//
//  SettingsViewController.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

enum MyRows: Int {
    case version
}

class AboutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var presenter = AboutPresenter()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == MyRows.version.rawValue {
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: VersionNumberTableViewCell.cellReuseIdentifier) as! VersionNumberTableViewCell
            
            return bannerCell
        }
        
        return UITableViewCell()
    }
}


extension AboutViewController: AboutView {
    func showError(text: String) {
        let alert = UIAlertController.createOkAlert(text: text)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
