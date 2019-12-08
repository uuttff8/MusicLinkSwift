//
//  ConvertPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Combine
import UIKit

class ConvertViewModel: ViewModel, ViewModelType {
    struct Input {
        let convertTriggered: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let data: AnyPublisher<LinksResponse?, Never>
    }
    
    struct Dependencies {
        let api: MLApiProvider
        let navigator: Navigator
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(_ input: ConvertViewModel.Input) -> ConvertViewModel.Output {
        
        let links = input.convertTriggered
            .receive(on: RunLoop.main)
            .flatMap { _ -> AnyPublisher<LinksResponse?, Never> in
                let url: String = UIPasteboard.general.getUrlFromPasteboard() ?? ""
                let location: String = Locale.current.regionCode ?? "RU"
                
                return self.dependencies.api.fetchLinks(url: url , userCountry: location)
        }
        .map { (response) -> LinksResponse? in
            guard let response = response else { return nil }
            return response
        }.eraseToAnyPublisher()
        
        return Output(data: links)
    }
}
