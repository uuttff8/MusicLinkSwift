//
//  SonglinkResponse.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation

struct LinksResponse: Codable {
    let entityUniqueId: String
    let userCountry: String
    let pageUrl: String
    let entitiesByUniqueId: Dictionary<String, EntitiesByUniqueId>
    let linksByPlatform: LinksByPlatform
    
    
    func getThumbnailUrl() -> String {
        return (entitiesByUniqueId[entityUniqueId]?.thumbnailUrl ?? "")
    }
    
    func getTitleAndArtistName() -> String {
        return "\(entitiesByUniqueId[entityUniqueId]?.title ?? "")" + "\n" + "\(entitiesByUniqueId[entityUniqueId]?.artistName ?? "")"
    }
}

struct EntitiesByUniqueId: Codable {
    let id: String
    let type: String
    
    let title: String?
    let artistName: String?
    let thumbnailUrl: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    
    let apiProvider: String
    let platforms: Array<String>
}

struct LinksByPlatform: Codable {
    let appleMusic: GenericPlatform?
    let spotify: GenericPlatform?
    let youtube: GenericPlatform?
    let youtubeMusic: GenericPlatform?
    let google: GenericPlatform?
    let pandora: GenericPlatform?
    let deezer: GenericPlatform?
    let amazonMusic: GenericPlatform?
    let tidal: GenericPlatform?
    let napster: GenericPlatform?
    let yandex: GenericPlatform?
    let itunes: GenericPlatform?
    let googleStore: GenericPlatform?
    let amazonStore: GenericPlatform?
}

struct GenericPlatform: Codable {
    let url: String
    let entityUniqueId: String
    let nativeAppUriMobile: String?
    let nativeAppUriDesktop: String?
}
