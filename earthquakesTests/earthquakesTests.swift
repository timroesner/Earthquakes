//
//  earthquakesTests.swift
//  earthquakesTests
//
//  Created by Tim Roesner on 7/3/20.
//

import XCTest
import CoreLocation
import Combine
@testable import Earthquakes

class earthquakesTests: XCTestCase {
    var token: Cancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        token?.cancel()
    }

    func testDecoding() {
        let testBundle = Bundle(for: type(of: self))
       
        guard let resourceURL = testBundle.url(forResource: "earthquake", withExtension: "json"),
              let data = try? Data(contentsOf: resourceURL),
              let decodedEarthquake = DataLoader.decodeEarthquakes(from: data).first
        else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(decodedEarthquake.magnitude, 1.1)
        XCTAssertEqual(decodedEarthquake.place, "27 km SW of Goldfield, Nevada")
        XCTAssertEqual(decodedEarthquake.time, Date(timeIntervalSince1970: 1593804694400 / 1000))
        XCTAssertEqual(decodedEarthquake.location.coordinate.latitude, CLLocationDegrees(37.523))
        XCTAssertEqual(decodedEarthquake.location.coordinate.longitude, CLLocationDegrees(-117.4402))
        XCTAssertEqual(decodedEarthquake.depth, 10.3)
    }
    
    func testDecodingAllWeek() {
        let testBundle = Bundle(for: type(of: self))
       
        guard let resourceURL = testBundle.url(forResource: "earthquakes_all_week", withExtension: "json"),
              let data = try? Data(contentsOf: resourceURL),
              let decodedEarthquake = DataLoader.decodeEarthquakes(from: data).first
        else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(decodedEarthquake.magnitude, 0.7)
        XCTAssertEqual(decodedEarthquake.place, "8km NW of The Geysers, CA")
        XCTAssertEqual(decodedEarthquake.time, Date(timeIntervalSince1970: 1594358638300 / 1000))
        XCTAssertEqual(decodedEarthquake.location.coordinate.latitude, CLLocationDegrees(38.8326683))
        XCTAssertEqual(decodedEarthquake.location.coordinate.longitude, CLLocationDegrees(-122.8174973))
        XCTAssertEqual(decodedEarthquake.depth, 1.62)
    }
    
    func testDataTask() {
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson")!
        let expectation = XCTestExpectation()
        
        token = DataLoader.loadEarthquakeJson(from: url).sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                XCTFail()
            }
        } receiveValue: { earthquakes in
            XCTAssertTrue(earthquakes.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
    }
}
