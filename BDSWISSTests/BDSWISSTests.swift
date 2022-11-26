//
//  BDSWISSTests.swift
//  BDSWISSTests
//
//  Created by Oleksandr Chornyi on 17.11.2022.
//

import XCTest
import Reachability
import Charts
import NVActivityIndicatorView
import FlagKit
import RxCocoaRuntime
import RxSwift
import RxCocoa
import RxReachability

@testable import BDSWISS

final class BDSWISSTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testModels() {

        // Test Rate Model
        
        guard let data = loadJSONFile(fileName: "rate_json") else {
            fatalError("Couldn't read rate_json.json file")
        }
        
        /// The `XCTAssertNoThrow` can be used to get extra context about the throw
        XCTAssertNoThrow(try JSONDecoder().decode(Rate.self, from: data))

        guard let rate = try? JSONDecoder().decode(Rate.self, from: data) else {
            fatalError("Couldn't create rate model")
        }
        XCTAssertEqual(rate.symbol, "GBPCHF")
        XCTAssertEqual(rate.price, 1.3400699999999999)
        rate.price = 0.9999999
        XCTAssertEqual(rate.symbol, "GBPCHF")
        XCTAssertEqual(rate.price, 0.9999999)
        
        // Test Rates model
        
        guard let ratesData = loadJSONFile(fileName: "rates_json") else {
            fatalError("Couldn't read rates_json.json file")
        }
        
        /// The `XCTAssertNoThrow` can be used to get extra context about the throw
        XCTAssertNoThrow(try JSONDecoder().decode(Rates.self, from: ratesData))

        guard let rates = try? JSONDecoder().decode(Rates.self, from: ratesData) else {
            fatalError("Couldn't create rate model")
        }

        XCTAssertEqual(rates.rates?.count, 4)
        
        XCTAssertNotNil(rates.rates?[0])
        XCTAssertEqual(rates.rates?[0].symbol, "EURUSD")
        XCTAssertEqual(rates.rates?[0].price, 1.230545)

        
        XCTAssertNotNil(rates.rates?[1])
        XCTAssertEqual(rates.rates?[1].symbol, "GBPUSD")
        XCTAssertEqual(rates.rates?[1].price, 1.4068450000000001)

        XCTAssertNotNil(rates.rates?[2])
        XCTAssertEqual(rates.rates?[2].symbol, "EURGBP")
        XCTAssertEqual(rates.rates?[2].price, 0.87468)

        XCTAssertNotNil(rates.rates?[3])
        XCTAssertEqual(rates.rates?[3].symbol, "GBPCHF")
        XCTAssertEqual(rates.rates?[3].price, 1.3400699999999999)

        // Test ChartDataElement
        
        let cratDataElement = ChartDataElement()
        XCTAssertNotNil(cratDataElement)
        cratDataElement.addValue(rate: rate)
        XCTAssertEqual(cratDataElement.code, "GBPCHF")
        XCTAssertEqual(cratDataElement.values.count, 1)
        XCTAssertEqual(cratDataElement.values[0].y, 0.9999999)
        
    }
    
    func testManagers() {

        let dataManager = DataManager.shared
        XCTAssertNotNil(dataManager)

        let chartsDataManager = ChartsDataManager.shared
        XCTAssertNotNil(chartsDataManager)

        let notificationsManager = NotificationsManager.shared
        XCTAssertNotNil(notificationsManager)

        let timeObserver = TimerObserver.shared
        XCTAssertNotNil(timeObserver)

        let connectionObserver = ConnectionObserver.shared
        XCTAssertNotNil(connectionObserver)

    }
    
    func loadJSONFile(fileName: String) -> Data? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        
        print("The JSON string is: \(jsonString)")
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to Data")
        }
        
        return jsonData
    }
}
