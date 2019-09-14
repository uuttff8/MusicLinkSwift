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

class AboutViewController: UITableViewController {
    
    private var presenter = AboutPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension AboutViewController: AboutView {
    func showError(text: String) {
        let alert = UIAlertController.createOkAlert(text: text)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
