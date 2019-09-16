//
//  InfoTableViewCell.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 9/16/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class InfoTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var labelSong: UILabel!
    
    @IBOutlet weak var collectionViewToListenHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewToBuyHeight: NSLayoutConstraint!
    
    
    // TODO(uuttff8): Refactor to be as one (1) collection view
    @IBOutlet weak var collectionViewListen: UICollectionView!
    @IBOutlet weak var collectionViewBuy: UICollectionView!
    
    private var longpressToListen = UILongPressGestureRecognizer()
    private var longpressToBuy = UILongPressGestureRecognizer()
    private var servicesToListen  = Services()
    private var servicesToBuy  = Services()
    private var presenter = InfoPresenter()
    
    var baseVC: InfoViewController!
    var links: LinksResponse!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewListen.delegate = self
        collectionViewListen.dataSource = self
        
        collectionViewBuy.delegate = self
        collectionViewBuy.dataSource = self
        
        longpressToListen = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognizedToListen))
        collectionViewListen.addGestureRecognizer(longpressToListen)
        
        longpressToBuy = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognizedToBuy))
        collectionViewBuy.addGestureRecognizer(longpressToBuy)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        servicesToListen = presenter.checkListenServices(links)
        servicesToBuy = presenter.checkBuyServices(links)
        // Configure the view for the selected state
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    static var reuseId = "InfoTableViewCell"
    
    func bind(data: LinksResponse) {
        Imager.shared.loadImage(into: imageSong, link: data.getThumbnailUrl())
        labelSong.text = data.getTitleAndArtistName()
        
        writeSongToCoreData(data: data)
    }
    
    @objc func longPressGestureRecognizedToListen(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        if longPress.state == UIGestureRecognizer.State.began {
            let locationInTableView = longPress.location(in: collectionViewListen)
            let indexPath = collectionViewListen.indexPathForItem(at: locationInTableView)
            
            let url = URL(string: servicesToListen.links[indexPath!.item])
            let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            baseVC.present(activityVC, animated: true, completion: nil)
            print(indexPath?.row ?? "-0")
        }
    }
    
    @objc func longPressGestureRecognizedToBuy(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        if longPress.state == UIGestureRecognizer.State.began {
            let locationInTableView = longPress.location(in: collectionViewBuy)
            let indexPath = collectionViewBuy.indexPathForItem(at: locationInTableView)
            
            let url = URL(string: servicesToBuy.links[indexPath!.item])
            let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            baseVC.present(activityVC, animated: true, completion: nil)
            print(indexPath?.row ?? "-0")
        }
    }
    
    fileprivate func writeSongToCoreData(data: LinksResponse) {
        let context = CoreDataManager.context
        
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(data.getTitleAndArtistName(), forKey: "name")
        newUser.setValue(data.getThumbnailUrl(), forKey: "image")
        
        do {
            try context.save()
            print("\n Saving Core Data context is done. writeSongToCoreData(data:) \n")
        } catch {
            print("Failed saving")
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.servicesToListen.images.count
        } else {
            return self.servicesToBuy.images.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionViewListen.dequeueReusableCell(withReuseIdentifier: InfoServicesToListenCollectionViewCell.reuseId,
                                                                for: indexPath as IndexPath) as! InfoServicesToListenCollectionViewCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            
            cell.imageViewService.image = servicesToListen.images[indexPath.item]
            cell.imageViewService.adjustsImageSizeForAccessibilityContentSizeCategory = true
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionViewBuy.dequeueReusableCell(withReuseIdentifier: InfoServicesToBuyCollectionViewCell.reuseId,
                                                             for: indexPath as IndexPath) as! InfoServicesToBuyCollectionViewCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            
            cell.imageViewService.image = servicesToBuy.images[indexPath.item]
            cell.imageViewService.adjustsImageSizeForAccessibilityContentSizeCategory = true
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView.tag == 0 {
            let url = URL(string: servicesToListen.links[indexPath.item])!
            UIApplication.shared.open(url)
            debugPrint("\n")
            NSLog("\(url)")
            debugPrint("\n")
            
        } else if collectionView.tag == 1 {
            let url = URL(string: servicesToBuy.links[indexPath.item])!
            UIApplication.shared.open(url)
            debugPrint("\n")
            NSLog("\(url)")
            debugPrint("\n")
        }
        
    }
    
    // make collection views autoresize
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionViewToListenHeight.constant = collectionViewListen.contentSize.height
        collectionViewToBuyHeight.constant = collectionViewBuy.contentSize.height
    }
}


extension InfoTableViewCell: UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 0 {
            return CGSize(width: 64.0, height: 64.0)
        } else if collectionView.tag == 1 {
            return CGSize(width: 64.0, height: 64.0)
        }
        
        return CGSize(width: 64.0, height: 64.0)
    }
}
