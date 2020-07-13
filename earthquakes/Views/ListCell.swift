//
//  ListCell.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/4/20.
//

import SwiftUI
import CoreLocation
import CoreUI

struct ListCell: View {
    let earthquake: Earthquake
    
    var body: some View {
        NavigationLink(destination: DetailView(earthquake: earthquake), label: {
            VStack(alignment: .leading, spacing: .standardMargin) {
                HStack {
                    Text("M - \(earthquake.magnitude.fraction(minDigits: 1, maxDigits: 2))")
                        .font(.titleStyle)
                    Spacer()
                    Text(earthquake.time.relativeToNow())
                        .font(.bodyStyle)
                        .foregroundColor(.secondary)
                }
                Text(earthquake.place)
                    .font(.bodySmallStyle)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Magnitude \(earthquake.magnitude.fraction(minDigits: 1, maxDigits: 2)), \(earthquake.place), \(earthquake.time.relativeToNow())"))
            .accessibility(hint: Text("Double tap to view more details"))
            .padding(.vertical, .standardMargin)
            .padding(.trailing, .standardMargin)
        })
    }
}

// MARK: - Preview

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        let testEarthquake = Earthquake(magnitude: 3.5, place: "2km East of Somewhere", time: Date(timeIntervalSinceNow: -135), url: nil, location: CLLocation(latitude: 23.00, longitude: 21.00), depth: 4.2)
        
        return ListCell(earthquake: testEarthquake).previewLayout(.sizeThatFits)
    }
}
