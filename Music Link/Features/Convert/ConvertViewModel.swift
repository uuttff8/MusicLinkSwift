//
//  ConvertPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConvertViewModel: ViewModel, ViewModelType {
    struct Input {
        let convertToLinkTriggered: Driver<Void>
    }
    
    struct Output {
        let convertToLinkTriggered: Driver<LinksResponse?>
    }
    
    func transform(_ input: ConvertViewModel.Input) -> ConvertViewModel.Output {
        let convertToLinkTriggered = input.convertToLinkTriggered.asDriver(onErrorJustReturn: ()).map { () -> LinksResponse? in
            
            guard let url = UIPasteboard.general.getUrlFromPasteboard() else {
                //            self.presenterView?.showError(title: "Invalid copied link", message: nil)
                //            self.presenterView?.hidePasteButtonLoading()
                return nil
            }
            
            
            //let url = "https://music.apple.com/ru/album/pink-phloyd/1257008616?i=1257009042&l=en"
            //let url = "https://music.apple.com/ru/album/drugstyle-feat-lil-krystalll/1475657096?i=1475657106&l=en"
            //let url = "https://music.apple.com/ru/album/symphony-no-7-in-a-major-op-92-ii-allegretto/1439271019?i=1439271033&l=en"
            //let url = "https://music.apple.com/us/album/kitchen/1443108737?i=1443109064&uo=4&app=music&ls=1&at=1000lHKX"
            var link: LinksResponse!
            
            NetManager.shared.getLinks(url: url, userCountry: Locale.current.regionCode ?? "RU").execute(onSubscribe: {
                print(String(describing: Locale.current.regionCode) + " \n")
            }, onNext: { (response: HTTPURLResponse, data: Data) in
                let jsonDecoder = JSONDecoder()
                
                if (response.statusCode == 200) {
                    if let loginResponse: LinksResponse = try? jsonDecoder.decode(LinksResponse.self, from: data) {
                        link = loginResponse
                    } else {
                        self.logger.info("Invalid copied link")
                        
                    }
                } else if (response.statusCode == 404) {
                    //self.presenterView?.showError(title: "Invalid copied link", message: nil)
                    self.logger.info("Invalid copied link")
                    
                }
                
                //self.presenterView?.hidePasteButtonLoading()
            }, onError: { (e: Error) in
                //self.presenterView?.showError(title: e.localizedDescription, message: nil)
                //self.presenterView?.hidePasteButtonLoading()
            }).disposed(by: self.rx.disposeBag)
            
            return link
        }
        return Output(convertToLinkTriggered: convertToLinkTriggered)
        
    }
}
