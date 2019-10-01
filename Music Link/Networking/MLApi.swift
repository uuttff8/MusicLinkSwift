//
//  MLApi.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire

public enum MLAPI {
    case getLinks(url: String, userCountry: String)
}

extension MLAPI: MLApiMethod {
 
    public var methodURL: String {
        switch self {
        case .getLinks(_, _): return "links"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getLinks(_, _): return .get
        }
    }
    
    public var parameters: [String:Any] {
        switch self {
        case .getLinks(let url, let userCountry): return ["url": url, "userCountry": userCountry, "key": ApiConstants.KEY.rawValue,]
        }
        
    }
}




