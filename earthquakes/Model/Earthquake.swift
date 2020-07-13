//
//  Earthquake.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/3/20.
//

import MapKit
import CoreLocation

struct Earthquake: Hashable, Identifiable {
    let id = UUID()
    let magnitude: Double
    let place: String
    let time: Date
    let url: URL?
    let location: CLLocation
    let depth: Double
    
    // MARK: Hashable
    
    static func == (lhs: Earthquake, rhs: Earthquake) -> Bool {
        return lhs.magnitude == rhs.magnitude &&
            lhs.place == rhs.place &&
            lhs.time == rhs.time &&
            lhs.location.coordinate.latitude == rhs.location.coordinate.latitude &&
            lhs.location.coordinate.longitude == rhs.location.coordinate.longitude &&
            lhs.depth == rhs.depth
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(magnitude)
        hasher.combine(place)
        hasher.combine(time)
        hasher.combine(location.coordinate.latitude)
        hasher.combine(location.coordinate.longitude)
        hasher.combine(depth)
    }
}
