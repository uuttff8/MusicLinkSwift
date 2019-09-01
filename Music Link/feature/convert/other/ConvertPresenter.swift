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
            self.presenterView?.showError(text: "Invalid copied link")
            self.presenterView?.hidePasteButtonLoading()
            return
        }
        let locale = Locale(identifier: "LocaleNewId")
        
        NetManager.shared.getLinks(url: url, userCountry: locale.regionCode ?? "").execute(onSubscribe: {
            print("onSubs")
        }, onNext: { (response: HTTPURLResponse, data: Data) in
            self.printDada(data: data, response: response)
            
            if (response.statusCode == 200) {
                if let loginResponse: LinksResponse = try? self.jsonDecoder.decode(LinksResponse.self, from: data) {
                    self.presenterView?.onConvertedLink(links: loginResponse)
                } else {
                    self.presenterView?.showError(text: "Что-то пошло не так")
                }
            } else if (response.statusCode == 404) {
                self.presenterView?.showError(text: "Invalid copied link")
            } else {
                self.presenterView?.showError(text: "Check your internet connection")
            }
            
            self.presenterView?.hidePasteButtonLoading()
        }, onError: { (e: Error) in
            self.presenterView?.showError(text: e.localizedDescription)
        })
        .disposed(by: disposableBag)
        
    }
    
}

protocol ConvertView: NetView {
    func hidePasteButtonLoading()
    func onConvertedLink(links: LinksResponse)
}
