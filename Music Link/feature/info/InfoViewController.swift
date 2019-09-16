//
//  InfoViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var labelSong: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var links: LinksResponse!
    
    private var presenter = InfoPresenter()
    private var longpress = UILongPressGestureRecognizer()
    private var services  = Services()
    
    fileprivate func setupFirstOpen() {
        bind(data: links)
        
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        collectionView.addGestureRecognizer(longpress)
    }
    
    // MARK: - Controller initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_horiz"), style: .done, target: self, action: #selector(showAlertWithAllLinks))
                
        // Please refer to viewWillAppear to know when collection view cells is updated
        
        setupFirstOpen()
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        services = presenter.checkAllServices(links)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func bind(data: LinksResponse) {
        Imager.shared.loadImage(into: imageSong, link: data.getThumbnailUrl())
        labelSong.text = data.getTitleAndArtistName()
        
        presenter.writeSongToCoreData(data: data)
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
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        if longPress.state == UIGestureRecognizer.State.began {
            let locationInTableView = longPress.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: locationInTableView)
            
            let url = URL(string: services.links[indexPath!.item])
            let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            print(indexPath?.row ?? "-0")
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoServiceCollectionViewCell.reuseId,
                                                      for: indexPath as IndexPath) as! InfoServiceCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        cell.imageViewService.image = services.images[indexPath.item]
        cell.imageViewService.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let url = URL(string: services.links[indexPath.item])!
        UIApplication.shared.open(url)
        debugPrint("\n")
        NSLog("\(url)")
        debugPrint("\n")
    }
}

extension InfoViewController: InfoView {
    func showError(title: String, message: String?) {
        let alert = UIAlertController.createOkAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
