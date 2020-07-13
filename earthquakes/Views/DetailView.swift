//
//  DetailView.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/7/20.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreUI

struct DetailView: View {
    // MARK: - Public Properties
    
    let earthquake: Earthquake
    
    // MARK: - Private Properties
    
    @State private var coordinateRegion: MKCoordinateRegion
    
    init(earthquake: Earthquake) {
        self.earthquake = earthquake
        let mapSpan = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        self._coordinateRegion = State(initialValue: MKCoordinateRegion(center: earthquake.location.coordinate, span: mapSpan))
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                Map(coordinateRegion: $coordinateRegion, annotationItems: [earthquake]) { item in
                    MapMarker(coordinate: item.location.coordinate)
                }
                .edgesIgnoringSafeArea(.top)
                .frame(height: 2 * reader.size.height / 3)
                
                VStack(alignment: .leading) {
                    Text(earthquake.place)
                        .font(.titleLargeStyle)
                    Text(earthquake.time.relativeToNow())
                        .font(.bodyStyle)
                        .foregroundColor(.secondary)
                        .padding(.top, .tightMargin)
                    Spacer()
                    HStack {
                        VerticalTitleView(title: "Magnitude",
                                          value: "\(earthquake.magnitude.fraction(minDigits: 1, maxDigits: 2))",
                                          valueFont: .titleExtraLargeStyle)
                            .accessibilityElement(children: .combine)
                        Spacer()
                        VerticalTitleView(title: "Depth",
                                          value: "\(earthquake.depth.fraction(minDigits: 1, maxDigits: 2)) km")
                            .accessibilityElement(children: .combine)
                    }
                    Spacer()
                    if let url = earthquake.url {
                        Link("More at USGS.gov", destination: url)
                            .padding(.bottom, .wideMargin)
                    }
                }
                .padding(.horizontal, .wideMargin)
                
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

// MARK: - Preview

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let testEarthquake = Earthquake(magnitude: 3.5, place: "2km East of Somewhere", time: Date(timeIntervalSinceNow: -135), url: URL(string: "https://earthquake.usgs.gov/earthquakes/eventpage/ci39286951"), location: CLLocation(latitude: 5.637, longitude: 110.678), depth: 4.2)
        return DetailView(earthquake: testEarthquake)
    }
}
