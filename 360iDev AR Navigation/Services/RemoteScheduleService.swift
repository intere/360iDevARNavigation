//
//  RemoteScheduleService.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/20/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Foundation

typealias ScheduleCallback = (Schedule?, Error?) -> Void

class RemoteScheduleService {
    static let shared = RemoteScheduleService()

    /// Loads the schedule from the remote and then caches it to disk
    func cacheSchedule(completion: ScheduleCallback?) {
        guard let documentsDirectory = documentsDirectory else {
            return print("ERROR: documents directory couldn't be found")
        }
        loadSchedule { (schedule, error) in
            if let error = error {
                completion?(schedule, error)
                return print("ERROR: \(error.localizedDescription)")
            }
            guard let schedule = schedule, schedule.sessions.count > 0 else {
                completion?(nil, error)
                return print("ERROR: no schedule or no sessions in schedule")
            }
            let docsURL = URL(fileURLWithPath: documentsDirectory)
            let scheduleFile = URL(fileURLWithPath: "schedule.json", relativeTo: docsURL)
            do {
                let data = try JSONEncoder().encode(schedule)
                try data.write(to: scheduleFile, options: .atomicWrite)
                completion?(schedule, error)
            } catch {
                completion?(nil, error)
            }
        }
    }

}

// MARK: - Implementation

extension RemoteScheduleService {

    /// Gets you the path of the User Documents directory.
    var documentsDirectory: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first
    }

    /// Loads the schedule and calls back to your block.
    ///
    /// - Parameter completion: The block to handle the result
    func loadSchedule(completion: @escaping ScheduleCallback) {
        guard let url = URL(string: "https://360idev.com/wp-admin/admin-ajax.php") else {
            return completion(nil, nil)
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")

        let postData = "action=get_schedule".data(using: .utf8)
        request.httpBody = postData
        request.httpMethod = "POST"

        let defaultSession = URLSession(configuration: .default)

        defaultSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(nil, error)
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return completion(nil, nil)
            }
            guard let data = data else {
                return completion(nil, nil)
            }
            do {
                let schedule = try JSONDecoder().decode(Schedule.self, from: data)
                completion(schedule, nil)
            } catch {
                completion(nil, error)
            }

        }.resume()
    }
}
