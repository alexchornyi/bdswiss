//
//  BDSWISSUITestsLaunchTests.swift
//  BDSWISSUITests
//
//  Created by Oleksandr Chornyi on 17.11.2022.
//
import Charts
import FlagKit
import NVActivityIndicatorView
import Reachability
import RxCocoaRuntime
import RxSwift
import RxCocoa
import RxReachability

@testable import BDSWISS

import XCTest

final class BDSWISSUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
