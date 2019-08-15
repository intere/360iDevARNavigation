//
//  ScheduleService.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Foundation

struct ScheduleService {
    static var shared = ScheduleService()
    /// A map of DateEnum to (sorted) array of Sessions.
    var schedule = [DateEnum: [Session]]()

    /// Reads the schedule from the main bundle
    mutating func loadScheduleFromBundle() {
        guard let schedulePath = Bundle.main.path(forResource: "schedule", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: schedulePath)
        do {
            let data = try Data(contentsOf: url)
            let schedule = try JSONDecoder().decode(Schedule.self, from: data)
            buildSchedule(from: schedule)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

// MARK: - Implementation

private extension ScheduleService {

    mutating func buildSchedule(from schedule: Schedule) {
        var workingSet = [DateEnum: [Session]]()
        DateEnum.allSorted.forEach { workingSet[$0] = [Session]() }

        schedule.sessions.forEach { session in
            var s = session
            s.timestamp = s.computeTimestamp() ?? s.timestamp
            workingSet[session.date]?.append(s)
        }

        DateEnum.allSorted.forEach { date in
            workingSet[date] = workingSet[date]?.sorted { (first, second) -> Bool in
                return first.timestamp < second.timestamp
            }
        }

        self.schedule = workingSet
    }

}

extension Session {
    struct Constants {
        static let formatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MMMM d, yyyy H:mm a"

            return df
        }()
    }

    func computeTimestamp() -> Date? {
        let dateString = "\(date.rawValue) \(time)"
        return Constants.formatter.date(from: dateString)
    }
}
