//
//  ObservableType.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/9/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func ignoreAll() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where Element == Optional<T> {
        return filter { $0 != nil }.map { $0! }
    }

    func execute(_ selector: @escaping (Element) -> Void) -> Observable<Element> {
        return flatMap { result in
             return Observable
                .just(selector(result))
                .map { _ in result }
                .take(1)
        }
    }

    func count() -> Observable<(Element, Int)>{
        var numberOfTimesCalled = 0
        let result = map { _ -> Int in
            numberOfTimesCalled += 1
            return numberOfTimesCalled
        }

        return Observable.combineLatest(self, result)
    }

    func merge(with other: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self.asObservable(), other)
    }
    
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
