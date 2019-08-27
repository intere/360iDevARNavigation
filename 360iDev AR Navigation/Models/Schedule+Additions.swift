//
//  Schedule+Additions.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/21/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Foundation

extension Session {

    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        //August 25, 2019
        // 5:00 pm, 1:30 pm, etc
        formatter.dateFormat = "MMMM dd, yyyy, h:mm a"
        
        return formatter
    }()

    func compareDates(to currentTime: Date) -> Bool {
        let dateFormatter = Session.dateFormatter
        let day = date.rawValue

        guard let start = dateFormatter.date(from: day + ", " + time.uppercased()),
            let end = dateFormatter.date(from: day + ", " + endTime.uppercased()) else {
                return false
        }

        let result = currentTime.compare(start)
        let endResult = currentTime.compare(end)

        if (result == .orderedDescending || result == .orderedSame) &&
            (endResult == .orderedAscending || endResult == .orderedSame) {
            return true
        }

        return false
    }

}

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
