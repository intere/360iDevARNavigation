//
//  Schedule.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let schedule = try? JSONDecoder().decode(Schedule.self, from: jsonData)

import Foundation

// MARK: - Schedule
struct Schedule: Codable {
    let sessions: [Session]
    let strings: Strings
}

// MARK: - Session
struct Session: Codable {
    let postTitle: String
    let url: String
    let time, endTime: String
    let date: DateEnum
    let location: Location
    let color: String
    let speakers: [Speaker]

    enum CodingKeys: String, CodingKey {
        case postTitle = "post_title"
        case url, time
        case endTime = "end_time"
        case date, location, color, speakers
    }
}

enum DateEnum: String, Codable {
    case august252019 = "August 25, 2019"
    case august262019 = "August 26, 2019"
    case august272019 = "August 27, 2019"
    case august282019 = "August 28, 2019"

    static var allSorted: [DateEnum] {
        return [.august252019, .august262019, .august272019, .august282019]
    }
}

enum Location: String, Codable {
    case coloradoA = "Colorado A"
    case coloradoB = "Colorado B"
    case coloradoBallroom = "Colorado Ballroom"
    case liveAtJacks = "Live at Jacks"
    case maroonPeak = "Maroon Peak"
    case riNoBeerGarden = "RiNo Beer Garden"
}

// MARK: - Speaker
struct Speaker: Codable {
    let postTitle, featured: String
    let url: String
    let postImage: String

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

    enum CodingKeys: String, CodingKey {
        case postTitle = "post_title"
        case featured, url
        case postImage = "post_image"
    }
}

// MARK: - Strings
struct Strings: Codable {
    let moreInfo: String

    enum CodingKeys: String, CodingKey {
        case moreInfo = "more_info"
    }
}

