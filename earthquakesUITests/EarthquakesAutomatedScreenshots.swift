//
//  EarthquakesAutomatedScreenshots.swift
//  EarthquakesUITests
//
//  Created by Tim Roesner on 7/12/20.
//

import XCTest

class EarthquakesAutomatedScreenshots: XCTestCase {
    let app = XCUIApplication()

    override class func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    func testAutomatedScreenshots() {
        waitForExistence(of: app.cells.firstMatch)
        add(takePromoShot(name: "List"))
        
        app.cells.firstMatch.tap()
        waitForExistence(of: app.maps.firstMatch)
        add(takePromoShot(name: "Detail"))
        
        if app.navigationBars.buttons["Earthquakes"].exists {
            app.navigationBars.buttons["Earthquakes"].tap()
        }
        app.buttons["Filter"].tap()
        waitForExistence(of: app.buttons["Done"])
        add(takePromoShot(name: "Filter"))
    }
    
    func takePromoShot(name: String) -> XCTAttachment {
        let lang = Locale.preferredLanguages[0]
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = "\(lang)-\(name)"
        return attachment
    }
    
    func waitForExistence(of element: XCUIElement) {
        let predicate = NSPredicate(format: "exists == TRUE")
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
