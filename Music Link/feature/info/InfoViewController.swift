//
//  InfoViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var labelSong: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var links: LinksResponse!
    
    private var presenter = InfoPresenter()
    private var longpress = UILongPressGestureRecognizer()
    
    fileprivate func setupFirstOpen() {
        bind(data: links)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        collectionView.addGestureRecognizer(longpress)

        
        setupFirstOpen()
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        if longPress.state == UIGestureRecognizer.State.began {
            let locationInTableView = longPress.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: locationInTableView)
            print(indexPath?.row ?? "-0")
        }
    }
    
    let identifier = InfoServiceCollectionViewCell.identifier
    var items: Array<UIImage?> = [UIImage(named: "apple_music"), UIImage(named: "spotify")]
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath as IndexPath) as! InfoServiceCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        cell.imageViewService.image = self.items[indexPath.item]
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func bind(data: LinksResponse) {
        Imager.shared.loadImage(into: imageSong, link: data.getThumbnailUrl())
        labelSong.text = data.getTitleAndArtistName()
    }
}


extension InfoViewController: InfoView {
    
    func onCheckAllServices(links: LinksResponse) -> [GenericPlatform] {
        let servicesToListen: Array<GenericPlatform?> = [links.linksByPlatform.appleMusic, links.linksByPlatform.amazonMusic, links.linksByPlatform.deezer, links.linksByPlatform.google, links.linksByPlatform.napster, links.linksByPlatform.pandora, links.linksByPlatform.spotify, links.linksByPlatform.tidal, links.linksByPlatform.yandex, links.linksByPlatform.youtube, links.linksByPlatform.youtubeMusic]
        
        let mapServicesToListen = servicesToListen.filter { $0 != nil } as! [GenericPlatform]
        debugPrint(mapServicesToListen)
        return mapServicesToListen
    }
    
}
