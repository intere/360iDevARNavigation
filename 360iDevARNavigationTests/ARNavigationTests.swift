//
//  ARNavigationTests.swift
//  360iDevARNavigationTests
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

@testable import _60iDev_AR_Navigation
import XCTest

class ARNavigationTests: XCTestCase {

    func testFindJSONFile() {
        guard let schedulePath = Bundle.main.path(forResource: "schedule", ofType: "json") else {
            return XCTFail("No path for schedule.json")
        }
        let url = URL(fileURLWithPath: schedulePath)
        do {
            let data = try Data(contentsOf: url)
            let schedule = try JSONDecoder().decode(Schedule.self, from: data)
            XCTAssertNotEqual(0, schedule.sessions.count)
            print("There are \(schedule.sessions.count) sessions")

        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }

}
