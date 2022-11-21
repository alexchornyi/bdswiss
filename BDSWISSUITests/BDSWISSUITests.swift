//
//  BDSWISSUITests.swift
//  BDSWISSUITests
//
//  Created by Oleksandr Chornyi on 17.11.2022.
//

import Charts
import FlagKit
import NVActivityIndicatorView
import Reachability

@testable import BDSWISS

import XCTest

final class BDSWISSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        // This dismisses system alerts.
        XCUIDevice.shared.press(.home)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    // MARK: - Wait n seconds
    func wait(timeInSeconds: Double) {
        // Wait if app start first time we need open Preferences screen and then run tests
        let expectation = XCTestExpectation(description: "Your expectation")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeInSeconds + 1.0) // make sure it's more than what you used in AsyncAfter call.
    }
    
    func testRun() throws {
        let app = XCUIApplication()
        app.launch()

        wait(timeInSeconds: 2)
        
        
    }
}
