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
    
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var labelSong: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var links: LinksResponse!
    
    private var presenter = InfoPresenter()
    private var longpress = UILongPressGestureRecognizer()
    
    fileprivate func setupFirstOpen() {
        bind(data: links)
        
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        collectionView.addGestureRecognizer(longpress)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Please refer to viewWillAppear to know when collection view cells is updated
        
        setupFirstOpen()
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        services = onCheckAllServices()
        self.navigationController?.navigationBar.isHidden = false
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
    
    let identifier = InfoServiceCollectionViewCell.identifier
    var services: Services = Services()
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
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
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func bind(data: LinksResponse) {
        Imager.shared.loadImage(into: imageSong, link: data.getThumbnailUrl())
        labelSong.text = data.getTitleAndArtistName()
        
        writeSongToCoreData(data: data)
    }
    
    
    fileprivate func writeSongToCoreData(data: LinksResponse) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(data.getTitleAndArtistName(), forKey: "name")
        newUser.setValue(data.getThumbnailUrl(), forKey: "image")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}


extension InfoViewController: InfoView {
    
    func onCheckAllServices() -> Services {
        var services = Services()
        
        var images: Array<UIImage> = []
        var linker: Array<String> = []
        
        if let appleMusic = links.linksByPlatform.appleMusic {
            images.append(UIImage(named: "apple_music")!)
            linker.append(appleMusic.url)
        }
        if let amazonMusic = links.linksByPlatform.amazonMusic {
            images.append(UIImage(named: "amazon_music")!)
            linker.append(amazonMusic.url)
        }
        if let deezer = links.linksByPlatform.deezer {
            images.append(UIImage(named: "deezer")!)
            linker.append(deezer.url)
        }
        if let googleMusic = links.linksByPlatform.google {
            images.append(UIImage(named: "google_music")!)
            linker.append(googleMusic.url)
        }
        if let napster = links.linksByPlatform.napster {
            images.append(UIImage(named: "napster")!)
            linker.append(napster.url)
        }
        if let pandora = links.linksByPlatform.pandora {
            images.append(UIImage(named: "pandora")!)
            linker.append(pandora.url)
        }
        if let spotify = links.linksByPlatform.spotify {
            images.append(UIImage(named: "spotify")!)
            linker.append(spotify.url)
        }
        if let tidal = links.linksByPlatform.tidal {
            images.append(UIImage(named: "tidal")!)
            linker.append(tidal.url)
        }
        if let yandex = links.linksByPlatform.yandex {
            images.append(UIImage(named: "yandex_music")!)
            linker.append(yandex.url)
        }
        if let yt = links.linksByPlatform.youtube {
            images.append(UIImage(named: "yt")!)
            linker.append(yt.url)
        }
        if let yt_music = links.linksByPlatform.youtubeMusic {
            images.append(UIImage(named: "yt_music")!)
            linker.append(yt_music.url)
        }
        services.response = links
        services.links = linker
        services.images = images
        
        return services
    }
    
}
