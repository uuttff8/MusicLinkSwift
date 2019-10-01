//
//  MLApiTarget.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import Alamofire

public protocol MLApiMethod {
    //.get
    var httpMethod: HTTPMethod { get }
    //bot/all
    var methodURL: String { get }
    
    var parameters: [String:Any] { get }
}
