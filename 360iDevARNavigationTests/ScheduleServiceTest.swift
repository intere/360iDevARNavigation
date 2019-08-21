//
//  ScheduleServiceTest.swift
//  360iDevARNavigationTests
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

@testable import _60iDev_AR_Navigation
import XCTest

class ScheduleServiceTest: XCTestCase {

    func testPrintAug27Schedule() {
        ScheduleService.shared.reloadBundle()

        ScheduleService.shared.schedule[DateEnum.august272019]?.forEach { session in
            guard let timestamp = session.computeTimestamp() else {
                return XCTFail(session.postTitle)
            }

            print("\(session.time) - \(timestamp) - \(session.postTitle)")
        }
    }

    func testTimestampConversionReception() {
        ScheduleService.shared.reloadBundle()
        let eventName = "Evening Reception"
        let expectedDate = "2019-08-27T18:00:00"

        guard let event = ScheduleService.shared.findSession(titleContains: eventName).first else {
                return XCTFail()
        }
        guard let expected = Constants.dateFormat.date(from: expectedDate) else {
            return XCTFail()
        }

        XCTAssertEqual(expected, event.computeTimestamp())
        XCTAssertEqual(expected.timeIntervalSince1970, event.computeTimestamp()?.timeIntervalSince1970)
    }

    func testTimestampConversionStoreKit() {
        ScheduleService.shared.reloadBundle()
        let eventName = "StoreKit/Subscriptions"
        let expectedDate = "2019-08-27T16:45:00"

        guard let event = ScheduleService.shared.findSession(titleContains: eventName).first else {
            return XCTFail()
        }
        guard let expected = Constants.dateFormat.date(from: expectedDate) else {
            return XCTFail()
        }

        XCTAssertEqual(expected, event.computeTimestamp())
        XCTAssertEqual(expected.timeIntervalSince1970, event.computeTimestamp()?.timeIntervalSince1970)
    }



    func testSortingBug() {
        ScheduleService.shared.reloadBundle()
        let earlier = "StoreKit/Subscriptions"
        let later = "Evening Reception"

        guard let s1 = ScheduleService.shared.schedule[DateEnum.august272019]?.filter({ $0.postTitle.starts(with: earlier)}).first,
            let s2 = ScheduleService.shared.schedule[DateEnum.august272019]?.filter({ $0.postTitle == later }).first else {
                return XCTFail()
        }
        guard let t1 = s1.computeTimestamp(), let t2 = s2.computeTimestamp() else {
            return XCTFail()
        }

        XCTAssertTrue(t1 < t2)
    }

    func testLoadFromBundle() {
        ScheduleService.shared.reloadBundle()

        DateEnum.allSorted.forEach { date in
            guard let schedule = ScheduleService.shared.schedule[date] else {
                return XCTFail("Failed to get any schedule for date: \(date.rawValue)")
            }
            XCTAssertNotEqual(0, schedule.count)
        }

        DateEnum.allSorted.forEach { date in
            guard let schedule = ScheduleService.shared.schedule[date] else {
                return XCTFail("Failed to get the schedule")
            }

            schedule.forEach { (session) in
                print("Session \(session.time): \(session.postTitle)")
            }
        }
    }

    func testParseSpeakers() {
        ScheduleService.shared.reloadBundle()

        DateEnum.allSorted.forEach { date in
            guard let schedule = ScheduleService.shared.schedule[date] else {
                return XCTFail("Failed to get the schedule")
            }
            schedule.forEach { session in
                session.speakers.forEach { speaker in
                    guard let imageUrlString = speaker.imageUrlString else {
                        return XCTFail("Speaker without image: \(speaker.postTitle)")
                    }
                    print("Speaker '\(speaker.postTitle)' Image: \(imageUrlString)")
                }
            }
        }
    }

}

// MARK: - Helpers

extension ScheduleServiceTest {

    struct Constants {
        static let dateFormat: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            df.timeZone = TimeZone(abbreviation: "MDT")

            return df
        }()
    }
}


extension ScheduleService {

    /// Finds you sessions that contain the provided string in their title.
    ///
    /// - Parameter string: A string to match in the title.
    /// - Returns: An array of results.
    func findSession(titleContains string: String) -> [Session] {
        var results = [Session]()

        DateEnum.allSorted.forEach { date in
            schedule[date]?.forEach { session in
                guard session.postTitle.lowercased().contains(string.lowercased()) else {
                    return
                }
                results.append(session)
            }
        }

        return results
    }

}
