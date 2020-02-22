//
//  BasePresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import Combine

class BasePresenter<BaseView> {
  
    var presenterView: BaseView?
    var disposableBag = Set<AnyCancellable>()
    var jsonDecoder = JSONDecoder()
    
    func onCreate(view: BaseView) {
        self.presenterView = view
    }

    func onDestroy() {
        self.presenterView = nil
    }
    
    func printDada(data: Data, response: HTTPURLResponse) {
        print(response.url!)
        print(String(data: data, encoding: .utf8)!)
    }
}
