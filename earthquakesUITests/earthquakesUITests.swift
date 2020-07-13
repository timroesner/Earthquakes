//
//  EarthquakesUITests.swift
//  EarthquakesUITests
//
//  Created by Tim Roesner on 7/3/20.
//

import XCTest

class EarthquakesUITests: XCTestCase {
    let app = XCUIApplication()

    override class func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    func testDetailNavigation() {
        waitForExistence(of: app.cells.firstMatch)
        app.cells.firstMatch.tap()
        waitForExistence(of: app.maps.firstMatch)
    }

    func testLocationPermission() throws {
        app.resetAuthorizationStatus(for: .location)
        app.buttons["Filter"].tap()
        app.accessibilityScroll(.down)
        app.cells["10km Radius"].firstMatch.tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        waitForExistence(of: springboard.alerts.firstMatch)
    }
    
    func waitForExistence(of element: XCUIElement) {
        let predicate = NSPredicate(format: "exists == TRUE")
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
