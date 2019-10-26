//
//  ConvertPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class ConvertViewModel: ViewModel, ViewModelType {
    struct Input {
        let convertTriggered: Driver<Void>
    }
    
    struct Output {
        let data: Driver<LinksResponse?>
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
            .asObservable()
            .flatMap { _ in
                // should be fixed UIPasteboard.general.getUrlFromPasteboard()! to handle logic, same as userCountry
                self.dependencies.api.fetchLinks(url: UIPasteboard.general.getUrlFromPasteboard()!, userCountry: "RU")
        }.map { (links) -> LinksResponse? in
            guard let links = links else { return nil }
            return links
        }.asDriver(onErrorJustReturn: nil)

            
        return Output(data: links)
    }
}