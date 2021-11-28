//
//  Filter.swift
//  Earthquakes
//
//  Created by Tim Roesner on 7/12/20.
//

import Foundation

protocol TitleRepresentable: Equatable {
    var title: String { get }
}

enum TimeframeFilter: String, TitleRepresentable, CaseIterable {
    case oneHour, oneDay, sevenDays, thirtyDays
    
    var title: String {
        switch self {
        case .oneHour: return "Past Hour"
        case .oneDay: return "Past Day"
        case .sevenDays: return "Past 7 Days"
        case .thirtyDays: return "Past 30 Days"
        }
    }
    
    var urlComponent: String {
        switch self {
        case .oneHour: return "hour"
        case .oneDay: return "day"
        case .sevenDays: return "week"
        case .thirtyDays: return "month"
        }
    }
}

enum MagnitudeFilter: String, TitleRepresentable, CaseIterable {
    case all, onePlus, twoPointFivePlus, fourPointFivePlus
    
    var title: String {
        switch self {
        case .all: return "All"
        case .onePlus: return "1.0+"
        case .twoPointFivePlus: return "2.5+"
        case .fourPointFivePlus: return "4.5+"
        }
    }
    
    var urlComponent: String {
        switch self {
        case .all: return "all"
        case .onePlus: return "1.0"
        case .twoPointFivePlus: return "2.5"
        case .fourPointFivePlus: return "4.5"
        }
    }
}

enum LocationFilter: String, TitleRepresentable, CaseIterable {
    case all, radius50, radius100, radius200, radius400
    
    var title: String {
        switch self {
        case .all: return "All"
        case .radius50: return "50km Radius"
        case .radius100: return "100km Radius"
        case .radius200: return "200km Radius"
        case .radius400: return "400km Radius"
        }
    }
    
    /// The radius of the filter distance in meters.
    var distance: Double {
        switch self {
        case .all: return Double.greatestFiniteMagnitude
        case .radius50: return 50_000
        case .radius100: return 100_000
        case .radius200: return 200_000
        case .radius400: return 400_000
        }
    }
}
