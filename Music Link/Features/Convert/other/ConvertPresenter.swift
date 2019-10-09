//
//  ConvertPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class ConvertPresenter: BasePresenter<ConvertView> {
    func startConvertingToLink() {
        
        guard let url = UIPasteboard.general.getUrlFromPasteboard() else {
            self.presenterView?.showError(title: "Invalid copied link", message: nil)
            self.presenterView?.hidePasteButtonLoading()
            return
        }
        
        
        //let url = "https://music.apple.com/ru/album/pink-phloyd/1257008616?i=1257009042&l=en"
        //let url = "https://music.apple.com/ru/album/drugstyle-feat-lil-krystalll/1475657096?i=1475657106&l=en"
        //let url = "https://music.apple.com/ru/album/symphony-no-7-in-a-major-op-92-ii-allegretto/1439271019?i=1439271033&l=en"
        //let url = "https://music.apple.com/us/album/kitchen/1443108737?i=1443109064&uo=4&app=music&ls=1&at=1000lHKX"
        
        NetManager.shared.getLinks(url: url, userCountry: Locale.current.regionCode ?? "RU").execute(onSubscribe: {
            print("onSubs")
            print(String(describing: Locale.current.regionCode) + " \n")
        }, onNext: { (response: HTTPURLResponse, data: Data) in
            self.printDada(data: data, response: response)
            
            if (response.statusCode == 200) {
                if let loginResponse: LinksResponse = try? self.jsonDecoder.decode(LinksResponse.self, from: data) {
                    self.presenterView?.onConvertedLink(links: loginResponse)
                } else {
                    self.presenterView?.showError(title: "Что-то пошло не так", message: nil)
                }
            } else if (response.statusCode == 404) {
                self.presenterView?.showError(title: "Invalid copied link", message: nil)
            }
            
            self.presenterView?.hidePasteButtonLoading()
        }, onError: { (e: Error) in
            self.presenterView?.showError(title: e.localizedDescription, message: nil)
            self.presenterView?.hidePasteButtonLoading()
        }).disposed(by: disposableBag)
    }
}

protocol ConvertView: NetView {
    func hidePasteButtonLoading()
    func onConvertedLink(links: LinksResponse)
}
