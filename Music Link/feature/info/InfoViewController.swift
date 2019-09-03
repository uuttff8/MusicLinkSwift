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
    
    var links: LinksResponse!
    
    private var presenter = InfoPresenter()
    
    fileprivate func setupFirstOpen() {
        onCheckAllServices()
        bind(data: links)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupFirstOpen()
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    let reuseIdentifier = "InfoServiceCollectionViewCell"
    var items = [UIImage(named: "apple_music"), UIImage(named: "soundcloud")]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! InfoServiceCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.imageViewService.image = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
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
    func onCheckAllServices() {
        let servicesToListen: Array<GenericPlatform?> = [links.linksByPlatform.appleMusic, links.linksByPlatform.amazonMusic, links.linksByPlatform.deezer, links.linksByPlatform.google, links.linksByPlatform.itunes, links.linksByPlatform.napster, links.linksByPlatform.pandora, links.linksByPlatform.spotify, links.linksByPlatform.tidal, links.linksByPlatform.yandex, links.linksByPlatform.youtube, links.linksByPlatform.youtubeMusic]
        
        let mapServicesToListen = servicesToListen.filter { $0 != nil }
        debugPrint(mapServicesToListen)
    }
    
    
}
