//
//  InfoPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

class InfoPresenter: BasePresenter<InfoView> {
    
    func checkListenServices(_ links: LinksResponse) -> Services {
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
    
    func checkBuyServices(_ links: LinksResponse) -> Services {
        var services = Services()
        
        var images: Array<UIImage> = []
        var linker: Array<String> = []
        
        if let itunes = links.linksByPlatform.itunes {
            images.append(UIImage(named: "itunes_store")!)
            linker.append(itunes.url)
        }
        if let googleStore = links.linksByPlatform.googleStore {
            images.append(UIImage(named: "google_play_store")!)
            linker.append(googleStore.url)
        }
        if let amazonStore = links.linksByPlatform.amazonStore {
            images.append(UIImage(named: "amazon")!)
            linker.append(amazonStore.url)
        }
        
        services.response = links
        services.links = linker
        services.images = images
        
        return services
    }
    
}

protocol InfoView: BaseView {
}
