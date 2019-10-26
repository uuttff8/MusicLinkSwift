//
//  MLApi.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MLApiLinksProvider {
    func fetchLinks(url: String, userCountry: String) -> Observable<LinksResponse?>
}

protocol MLApiProvider: MLApiLinksProvider { }

final class MLApi: MLApiProvider {
    private struct Constants {
        static let apiKey = "b73e8c14-a91e-43c0-be99-165783231b56"
        static let songlinkApiUrl = "https://api.song.link/v1-alpha.1/"
    }
    
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchLinks(url: String, userCountry: String) -> Observable<LinksResponse?> {
        return httpClient.get(url: "\(Constants.songlinkApiUrl)links?url=\(url)?key=\(Constants.apiKey)&userCountry=\(userCountry)").map { data -> LinksResponse? in
                guard let data = data,
                let response = try? JSONDecoder().decode(LinksResponse.self, from: data) else {
                    return nil
            }
            
            return response
        }
    }
}


//extension MLAPI: MLApiMethod {
// 
//    public var methodURL: String {
//        switch self {
//        case .getLinks(_, _): return "links"
//        }
//    }
//    
//    public var httpMethod: HTTPMethod {
//        switch self {
//        case .getLinks(_, _): return .get
//        }
//    }
//    
//    public var parameters: [String:Any] {
//        switch self {
//        case .getLinks(let url, let userCountry): return ["url": url, "userCountry": userCountry, "key": ApiConstants.KEY.rawValue,]
//        }
//        
//    }
//}




