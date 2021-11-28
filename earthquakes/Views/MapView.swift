//
//  MapView.swift
//  Earthquakes
//
//  Created by Tim Roesner on 7/9/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    // MARK: - Public Properties
    
    @ObservedObject
    var dataManager: DataManager
    
    // MARK: - Private Properties
    
    @State private var isShowingFilters: Bool = false
    @State private var coordinateRegion: MKCoordinateRegion
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        let mapSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        let defaultCoordinate = dataManager.currentLocation?.coordinate ?? .init(latitude: 40.6, longitude: -117.6)
        self._coordinateRegion = State(initialValue: MKCoordinateRegion(center: defaultCoordinate, span: mapSpan))
    }
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $coordinateRegion, showsUserLocation: true, annotationItems: dataManager.filteredEarthquakes) { earthquake in
                MapAnnotation(coordinate: earthquake.location.coordinate) {
                    NavigationLink(
                        destination: DetailView(earthquake: earthquake),
                        label: {
                            Text("\(earthquake.magnitude.fraction(minDigits: 2, maxDigits: 2))")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Circle().foregroundColor(earthquake.annotationColor))
                    })
                }
            }
            .ignoresSafeArea()
            .navigationBarTitle("Earthquakes", displayMode: .inline)
            .navigationBarItems(trailing: filterButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var filterButton: some View {
        Button {
            self.isShowingFilters = true
        } label: {
            Image(systemName: dataManager.isFilterEnabled ?
                    "line.horizontal.3.decrease.circle.fill" :
                    "line.horizontal.3.decrease.circle")
                .imageScale(.large)
        }.sheet(isPresented: $isShowingFilters, content: {
            FilterView(dataManager: dataManager)
        })
        .accessibility(label: Text("Filter"))
        .accessibility(value: dataManager.isFilterEnabled ? Text("Enabled") : Text(""))
    }
}

private extension Earthquake {
    var annotationColor: Color {
        switch magnitude {
        case ..<2.5:
            return Color(.systemGreen)
        case 2.5..<3.5:
            return Color(.systemYellow)
        case 3.5..<4.5:
            return Color(.systemOrange)
        case 4.5...:
            return Color(.systemRed)
        default:
            fatalError("Magnitude \(magnitude) is out of bounds")
        }
    }
}

#if DEBUG
// MARK: - Preview

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(dataManager: DataManager())
    }
}
#endif
