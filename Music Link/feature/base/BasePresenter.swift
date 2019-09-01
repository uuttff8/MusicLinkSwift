//
//  BasePresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import RxSwift

class BasePresenter<BaseView> {
  
    var presenterView: BaseView?
    var disposableBag = DisposeBag.init()
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

extension ObservableType {
    public func execute(onSubscribe: (() -> Void)? = nil, onDispose: (() -> Void)? = nil, onNext: ((Self.Element) throws -> Void)? = nil, onError: ((Error) throws -> Void)? = nil) -> Disposable {
        return self.do(onNext: onNext, onError: onError, onCompleted: nil, onSubscribe: onSubscribe, onSubscribed: nil, onDispose: onDispose).subscribe()
        
    }
}
