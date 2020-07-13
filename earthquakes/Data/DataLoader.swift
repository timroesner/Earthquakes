//
//  DataLoader.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/3/20.
//

import Foundation
import Combine
import CoreLocation

enum DataLoader {
    static func loadEarthquakeJson(from url: URL) -> AnyPublisher<[Earthquake], URLError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map({ decodeEarthquakes(from: $0.data) })
            .eraseToAnyPublisher()
    }
    
    static func decodeEarthquakes(from jsonData: Data) -> [Earthquake] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        do {
            let root = try decoder.decode(EarthquakeRoot.self, from: jsonData)
            return root.earthquakes
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

// MARK: - Decodable Types

private struct EarthquakeRoot: Decodable {
    let earthquakes: [Earthquake]
    
    enum CodingKeys: CodingKey {
        case features
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let features = try container.decode([Feature].self, forKey: .features)
        
        earthquakes = features.compactMap({ feature in
            let properties = feature.properties
            let geometry = feature.geometry
            
            guard let magnitude = properties.mag else { return nil }
            let place = properties.place
            let time = properties.time
            let url = URL(string: properties.url)
            let coordinates = CLLocation(latitude: geometry.coordinates[1], longitude: geometry.coordinates[0])
            let depth = geometry.coordinates[2]
            return Earthquake(magnitude: magnitude, place: place, time: time, url: url, location: coordinates, depth: depth)
        })
    }
}

private struct Feature: Codable {
    let properties: Properties
    let geometry: Geometry
}

private struct Properties: Codable {
    let mag: Double?
    let place: String
    let time: Date
    let url: String
}

private struct Geometry: Codable {
    let coordinates: [Double]
}
