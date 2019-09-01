//
//  NetManager.swift
//
//  Created by uuttff8 on 8/31/19.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class NetManager {
    
    typealias MLObservable = Observable<(HTTPURLResponse, Data)>
    
    static let shared = NetManager()

    private var API_LINK: String {
        get {
            return ApiConstants.STAGE.rawValue
        }
    }
    
    func getLinks(url: String, userCountry: String) -> MLObservable {
        return api(apiMethod: .getLinks(url: url, userCountry: userCountry))
    }
    
    fileprivate func api(apiMethod: MLAPI) -> MLObservable {
        printRequest(apiMethod: apiMethod)
        
        var encoding: ParameterEncoding
        
        if(apiMethod.httpMethod == .get) {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding.prettyPrinted
        }
        
        return RxAlamofire
            .requestData(apiMethod.httpMethod,
                         (API_LINK+apiMethod.methodURL).encodeUrl,
                         parameters: apiMethod.parameters,
                         encoding: encoding)
            .asObservable()
    }
    
    private func printRequest(apiMethod: MLAPI) {
        print("\n")
        print((API_LINK+apiMethod.methodURL).encodeUrl)
        print(apiMethod.parameters)
        print("\n")
    }
}
