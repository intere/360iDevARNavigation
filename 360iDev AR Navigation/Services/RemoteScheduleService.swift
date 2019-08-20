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

    func loadSchedule(completion: @escaping ScheduleCallback) {
        guard let url = URL(string: "https://360idev.com/wp-admin/admin-ajax.php") else {
//        guard let url = URL(string: "http://360idev.com:12345/wp-admin/admin-ajax.php") else {
            return completion(nil, nil)
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
        request.addValue("https://360idev.com/schedule/", forHTTPHeaderField: "referer")
        request.addValue("360idev.com", forHTTPHeaderField: "authority")
        request.addValue("https://360idev.com", forHTTPHeaderField: "origin")
        request.addValue("cors", forHTTPHeaderField: "sec-fetch-mode")
        request.addValue("same-origin", forHTTPHeaderField: "sec-fetch-site")

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
