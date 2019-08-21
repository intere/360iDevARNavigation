//
//  Schedule+Additions.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/21/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Foundation

extension DateEnum {

    static var allSorted: [DateEnum] {
        return [.august252019, .august262019, .august272019, .august282019]
    }
}

extension Speaker {

    var imageUrlString: String? {
        let parts = postImage.split(separator: "\"")

        for idx in 0..<parts.count where parts[idx].contains("src=") {
            guard idx + 1 < parts.count else {
                continue
            }
            return String(parts[idx+1]).replacingOccurrences(of: "&amp;", with: "&")
        }
        return nil
    }

}
