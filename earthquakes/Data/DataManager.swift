//
//  DataManager.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/3/20.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class DataManager: NSObject, ObservableObject {
    // MARK: - Public Properties
    
    @Published var filteredEarthquakes = [Earthquake]()
    @Published var isLoading = false
    @Published var showLocationAlert = false
    
    var isFilterEnabled: Bool {
        timeframeFilter != .oneHour || magnitudeFilter != .all || locationFilter != .all
    }
    
    // MARK: - Filter Properties
    
    @AppStorage("timeframe_filter")
    private var timeframeFilterStorage: TimeframeFilter = .oneHour
    
    @Published
    var timeframeFilter: TimeframeFilter = .oneHour {
        didSet {
            timeframeFilterStorage = timeframeFilter
            load()
        }
    }
    
    @AppStorage("magnitude_filter")
    private var magnitudeFilterStorage: MagnitudeFilter = .all
    
    @Published
    var magnitudeFilter: MagnitudeFilter = .all {
        didSet {
            magnitudeFilterStorage = magnitudeFilter
            load()
        }
    }
    
    @AppStorage("location_filter")
    private var locationFilterStorage: LocationFilter = .all
    
    @Published
    var locationFilter: LocationFilter = .all {
        willSet {
            guard newValue != .all else { return }
            locationManager.requestWhenInUseAuthorization()
        }
        
        didSet {
            switch locationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                locationFilterStorage = locationFilter
                filteredEarthquakes = earthquakes.filter(isWithinLocationFilterRadius(_:))
            case .denied:
                showLocationAlert = true
            default:
                break
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var earthquakes = [Earthquake]()
    
    private let urlBase = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary"
    private var dataToken: Cancellable?
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            filteredEarthquakes = earthquakes.filter(isWithinLocationFilterRadius(_:))
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        magnitudeFilter = magnitudeFilterStorage
        timeframeFilter = timeframeFilterStorage
        locationFilter = locationFilterStorage
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Public API
    
    func load() {
        let url = URL(string: "\(urlBase)/\(magnitudeFilter.urlComponent)_\(timeframeFilter.urlComponent).geojson")!
        
        dataToken?.cancel()
        isLoading = true
        dataToken = DataLoader.loadEarthquakeJson(from: url)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] earthquakes in
                guard let self = self else { return }
                self.earthquakes = earthquakes
                self.filteredEarthquakes = earthquakes.filter(self.isWithinLocationFilterRadius(_:))
            }
    }
    
    func isWithinLocationFilterRadius(_ earthquake: Earthquake) -> Bool {
        guard locationFilter != .all, let currentLocation = currentLocation else { return true }
        
        let distance = earthquake.location.distance(from: currentLocation)
        return distance < locationFilter.distance
    }
}

extension DataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}
