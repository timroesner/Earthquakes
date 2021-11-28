//
//  EarthquakesApp.swift
//  Earthquakes
//
//  Created by Tim Roesner on 7/9/20.
//

import SwiftUI

@main
struct EarthquakesApp: App {
    @StateObject
    private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ListView(dataManager: dataManager)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                MapView(dataManager: dataManager)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
            }.onAppear {
                dataManager.load()
            }
        }
    }
}
