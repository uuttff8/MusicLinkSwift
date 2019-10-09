//
//  Pasteboard.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

extension UIPasteboard {
    func getUrlFromPasteboard() -> String? {
        let input = UIPasteboard.general.string ?? ""
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            return String(url)
        }
        
        return nil
    }
}
