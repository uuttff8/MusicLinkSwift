//
//  InfoTableViewCell.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 9/16/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

func nilFoundHere(_ object: Any? = nil) {
    print("nil found in \(object)")
}

protocol InfoTableViewCellDelegate: NSObject {
    func onLongPressed(activity: UIActivityViewController)
}

class InfoTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var labelSong: UILabel!
    
    @IBOutlet weak var collectionViewToListenHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewToBuyHeight: NSLayoutConstraint!
    
    // TODO(uuttff8): Refactor to be as one (1) collection view
    @IBOutlet weak var collectionViewListen: UICollectionView!
    @IBOutlet weak var collectionViewBuy: UICollectionView!
    
    // MARK: - Private Vars
    private var longpressToListen = UILongPressGestureRecognizer()
    private var longpressToBuy = UILongPressGestureRecognizer()
    private var presenter = InfoPresenter()
    
    private let cellHeightDivider: CGFloat = 11
    private let cellWidthDivider: CGFloat = 7
    
    // MARK: - Dynamic Public Variables
    weak var delegate: InfoTableViewCellDelegate?
    var servicesToListen: [ServiceProvider]!
    var servicesToBuy: [ServiceProvider]!
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        // Configure the view for the selected state
    }
    
    // MARK: - Deinit
    deinit {
        presenter.onDestroy()
    }
    
    static var reuseId = "InfoTableViewCell"
    
    // MARK: - Data binding
    func bind(data: LinksResponse, listen: [ServiceProvider], buy: [ServiceProvider]) {
        self.servicesToListen = listen
        self.servicesToBuy = buy
        
        handleCollectionViewHeight()
        
        Imager.shared.loadImage(into: imageSong, link: data.getThumbnailUrl())
        
        let titleAndArtist = data.getTitleAndArtistName()
        let attrTitleStr = NSMutableAttributedString(string: titleAndArtist.0 + " \n",
                                                     attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        )
        
        let attrArtistStr = NSMutableAttributedString(string: titleAndArtist.1,
                                                      attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        )
        
        attrTitleStr.append(attrArtistStr)
        
        
        labelSong.attributedText = attrTitleStr
        
        writeSongToCoreData(data: data)
    }
    
    // MARK: - UI
    
    fileprivate func handleCollectionViewHeight() {
        let size = UIScreen.main.bounds
        let height = size.height / self.cellHeightDivider
        
        if servicesToListen.count <= 5 {
            collectionViewToListenHeight.constant = height
            
        } else if servicesToListen.count <= 10 {
            collectionViewToListenHeight.constant = height * 2
            
        } else if servicesToListen.count <= 15 {
            collectionViewToListenHeight.constant = height * 3
            
        }
        
        if servicesToBuy.count <= 5 {
            collectionViewToBuyHeight.constant = height
            
        } else if servicesToBuy.count <= 10 {
            collectionViewToBuyHeight.constant = height * 2
            
        } else if servicesToBuy.count <= 15 {
            collectionViewToBuyHeight.constant = height * 3
            
        }
    }
    
    
    // MARK: - Longpress handling
    @objc private func longPressGestureRecognizedToListen(gestureRecognizer: UIGestureRecognizer) {
        handleLongPress(for: collectionViewListen, data: servicesToListen, gestureRecognizer: gestureRecognizer)
    }
    
    @objc private func longPressGestureRecognizedToBuy(gestureRecognizer: UIGestureRecognizer) {
        handleLongPress(for: collectionViewBuy, data: servicesToBuy, gestureRecognizer: gestureRecognizer)
    }
    
    private func handleLongPress(
        for collection: UICollectionView,
        data service: [ServiceProvider],
        gestureRecognizer: UIGestureRecognizer
    ) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        if longPress.state == UIGestureRecognizer.State.began {
            let locationInTableView = longPress.location(in: collectionViewListen)
            
            guard let indexPath = collection.indexPathForItem(at: locationInTableView)
                else { nilFoundHere(); return }
            
            guard let url = URL(string: service[indexPath.item].link)
                else { nilFoundHere(); return}
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.delegate?.onLongPressed(activity: activityVC)
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewListen:
            return self.servicesToListen.count
        case collectionViewBuy:
            return self.servicesToBuy.count
        default:
            return 0
        }
    }
    
    // make a cell for each cell index path
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewListen:
            let cell = collectionViewListen
                .dequeueReusableCell(
                    withReuseIdentifier: InfoServicesToListenCollectionViewCell.reuseId,
                    for: indexPath as IndexPath
                ) as! InfoServicesToListenCollectionViewCell
            
            cell.bind(service: servicesToListen[indexPath.row])

            return cell
        case collectionViewBuy:
            let cell = collectionViewBuy
                .dequeueReusableCell(
                    withReuseIdentifier: InfoServicesToBuyCollectionViewCell.reuseId,
                    for: indexPath as IndexPath
                ) as! InfoServicesToBuyCollectionViewCell
            
            cell.bind(service: servicesToBuy[indexPath.row])
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        switch collectionView {
        case collectionViewListen:
            guard let url = URL(string: servicesToListen[indexPath.item].link) else { return }
            UIApplication.shared.open(url)
            logLongPress(url: url)

        case collectionViewBuy:
            guard let url = URL(string: servicesToBuy[indexPath.item].link) else { return }
            UIApplication.shared.open(url)
            logLongPress(url: url)
            
        default: break
        }
    }
    
    private func logLongPress(url: URL) {
        print("long press is active \n")
        NSLog("\(url)")
        print("\n")
    }
}


extension InfoTableViewCell: UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let size = UIScreen.main.bounds
        
        let height = size.height / cellHeightDivider
        let width = size.width / cellWidthDivider
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - CoreData entities
extension InfoTableViewCell {
    private func writeSongToCoreData(data: LinksResponse) {
        let context = CoreDataManager.shared.context
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        guard let result = try? context.fetch(request) as? [NSManagedObject]
            else {
                print("\(#file) \(#line) History CoreData NSManagedObject is not found")
                return
        }
        
        // if already in database, then do nothing
        if result.firstIndex(where: { (dataObject) -> Bool in
            guard let songName = dataObject.value(forKey: "name") as? String else { return false }
            
            return songName == data.getSongName()
        }) == nil {
            
            let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(data.getSongName(), forKey: "name")
            newUser.setValue(data.getThumbnailUrl(), forKey: "image")
            
            CoreDataManager.tryToSave(with: context)
        }
    }
    
}
