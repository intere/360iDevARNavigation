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

    func testLoadFromBundle() {
        ScheduleService.shared.loadScheduleFromBundle()

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
        ScheduleService.shared.loadScheduleFromBundle()

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
