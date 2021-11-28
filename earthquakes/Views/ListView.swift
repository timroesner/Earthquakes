//
//  ListView.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/3/20.
//

import SwiftUI

struct ListView: View {
    // MARK: - Public Properties
    
    @ObservedObject
    var dataManager: DataManager
    
    // MARK: - Private Properties
    
    @State
    private var isShowingFilters: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                if dataManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if dataManager.filteredEarthquakes.isEmpty {
                    Text("No data found. Try adjusting your filters")
                } else {
                    List(dataManager.filteredEarthquakes, id: \.self) { earthquake in
                        ListCell(earthquake: earthquake)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Earthquakes")
            .navigationBarItems(trailing: filterButton)
        }
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

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(dataManager: DataManager())
    }
}
