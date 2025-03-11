//
//  LocationObservationApp.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 3/10/25.
//

import SwiftUI

@main
struct LocationObservationApp: App {
    @State private var locationManager: LocationManager = .shared

    var body: some Scene {
        WindowGroup {
            LocationView()
                .task { locationManager.requestLocationPermissions() }
        }
    }
}
