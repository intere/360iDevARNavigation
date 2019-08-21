//
//  ScheduleService.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Foundation

class ScheduleService {
    static let shared = ScheduleService()

    enum Source {
        case bundle
        case documents
    }

    /// A map of DateEnum to (sorted) array of Sessions.
    var schedule = [DateEnum: [Session]]()

    /// Where the schedule was loaded from.
    var source = Source.bundle

    /// First, tries to load the schedule from the documents folder.
    /// If that doesn't work, then it loads it from the bundle.
    func reloadBundle() {
        if loadScheduleFromDocuments() {
            source = .documents
        } else {
            loadScheduleFromBundle()
            source = .bundle
        }
    }
}

// MARK: - Implementation

private extension ScheduleService {

    /// Gets you the path of the User Documents directory.
    var documentsDirectory: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first
    }

    /// Reads the schedule from the main bundle
    func loadScheduleFromBundle() {
        guard let schedulePath = Bundle.main.path(forResource: "schedule", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: schedulePath)
        do {
            self.schedule = try schedule(from: url)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    /// Loads the schedule from the documents folder (if it exists).  Returns
    /// a boolean to tell you whether or not it succeeded.
    ///
    /// - Returns: True if it succeeded, false if not.
    func loadScheduleFromDocuments() -> Bool {
        guard let documents = documentsDirectory else {
            return false
        }
        let docsPath = URL(fileURLWithPath: documents)
        let fileUrl = URL(fileURLWithPath: "schedule.json", relativeTo: docsPath)
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            return false
        }
        do {
            self.schedule = try schedule(from: fileUrl)
            return true
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return false
    }

    /// Reads the data from the provided file url, decodes it into JSON
    /// and then builds the schedule from that JSON.
    ///
    /// - Parameter file: The File URL to read.
    /// - Returns: The (organized and sorted) schedule.
    /// - Throws: If there's an error reading the file or decoding the JSON.
    func schedule(from fileUrl: URL) throws -> [DateEnum: [Session]] {
        let data = try Data(contentsOf: fileUrl)
        let schedule = try JSONDecoder().decode(Schedule.self, from: data)
        return buildSchedule(from: schedule)
    }

    /// Builds the schedule data structure from the raw schedule object.
    /// This function basically organizes the sessions by day and time.
    ///
    /// - Parameter schedule: The schedule to be organized.
    func buildSchedule(from schedule: Schedule) -> [DateEnum: [Session]] {
        var workingSet = [DateEnum: [Session]]()
        DateEnum.allSorted.forEach { workingSet[$0] = [Session]() }

        schedule.sessions.forEach { session in
            workingSet[session.date]?.append(session)
        }

        DateEnum.allSorted.forEach { date in
            workingSet[date] = workingSet[date]?.sorted { (first, second) -> Bool in
                guard let t1 = first.computeTimestamp(), let t2 = second.computeTimestamp() else {
                    return false
                }
                return t1 < t2
            }
        }

        return workingSet
    }

}

extension Session {
    struct Constants {
        static let formatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MMMM d, yyyy h:mm a"
            df.amSymbol = "am"
            df.pmSymbol = "pm"
            df.timeZone = TimeZone(abbreviation: "MDT")

            return df
        }()
    }

    func computeTimestamp() -> Date? {
        let dateString = "\(date.rawValue) \(time)"
        return Constants.formatter.date(from: dateString)
    }
}
