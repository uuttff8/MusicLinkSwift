//
//  HttpClient.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/26/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import RxSwift
import RxCocoa
import Combine
import Foundation

protocol HTTPClientProvider {
    func get(url: URL) -> AnyPublisher<Data?, Never>
    func post(url: String, params: [String: Any]) -> Observable<Data?>
}

final class HTTPClient: HTTPClientProvider {
    func get(url: URL) -> AnyPublisher<Data?, Never> {
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { Optional.init($0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func post(url: String, params: [String: Any]) -> Observable<Data?> {
        guard let url = URL(string: url) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData
        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catchErrorJustReturn(nil)
    }
}

