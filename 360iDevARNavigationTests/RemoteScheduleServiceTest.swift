//
//  RemoteScheduleServiceTest.swift
//  360iDevARNavigationTests
//
//  Created by Eric Internicola on 8/20/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

@testable import _60iDev_AR_Navigation
import XCTest

class RemoteScheduleServiceTest: XCTestCase {

    func testFetchSchedule() {
        let exp = expectation(description: "Load Schedule from 360iDev Site")

        RemoteScheduleService.shared.loadSchedule { (schedule, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                return XCTFail("Failed with error: \(error.localizedDescription)")
            }
            guard let schedule = schedule else {
                return XCTFail("No schedule")
            }

            XCTAssertNotEqual(0, schedule.sessions.count)
        }

        waitForExpectations(timeout: 30, handler: nil)
    }

}
