//
//  InfoPresenter.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoPresenter: BasePresenter<InfoView> {

}

protocol InfoView {
    func onCheckAllServices(links: LinksResponse) -> [GenericPlatform]
}
