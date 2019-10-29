//
//  InfoPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoPresenter: BasePresenter<InfoView> {
    
    func checkListenServices(_ links: LinksResponse) -> [ServiceProvider] {
        
        var genCell = ServiceProvider()
        
        let listen: [ServiceProvider?] = [
            genCell.create(title: "apple_music", link: links.linksByPlatform.appleMusic),
            genCell.create(title: "amazon_music", link: links.linksByPlatform.amazonMusic),
            genCell.create(title: "deezer", link: links.linksByPlatform.deezer),
            genCell.create(title: "google_music", link: links.linksByPlatform.google),
            genCell.create(title: "napster", link: links.linksByPlatform.napster),
            genCell.create(title: "pandora", link: links.linksByPlatform.pandora),
            genCell.create(title: "spotify", link: links.linksByPlatform.spotify),
            genCell.create(title: "yandex_music", link: links.linksByPlatform.yandex),
            genCell.create(title: "yt", link: links.linksByPlatform.youtube),
            genCell.create(title: "yt_music", link: links.linksByPlatform.youtubeMusic),
        ]
        
        return listen.compactMap { $0 }
    }
    
    func checkBuyServices(_ links: LinksResponse) -> [ServiceProvider] {
        
        var genCell = ServiceProvider()
        
        let buy: [ServiceProvider?] = [
            genCell.create(title: "itunes_store", link: links.linksByPlatform.itunes),
            genCell.create(title: "google_play_store", link: links.linksByPlatform.googleStore),
            genCell.create(title: "amazon", link: links.linksByPlatform.amazonStore)
        ]
        
        return buy.compactMap { $0 }
    }
}


protocol InfoView: BaseView {
}
