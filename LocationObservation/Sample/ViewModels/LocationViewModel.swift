//
//  LocationViewModel.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 3/10/25.
//

import SwiftUI
import Combine
import MapKit

/// An example implementation of `LocationObserver` that updates a map region with real-time location data.
///
/// `LocationViewModel` listens for location updates from ``LocationManager`` and adjusts the displayed
/// `MKCoordinateRegion` accordingly. This ensures that the map view stays centered on the user's current location.
///
/// - The `region` property defines the visible map area, which updates as new location data is received.
/// - `handleLocationUpdate(_:)` asynchronously updates the map's center coordinate on the main thread.
///
/// - Note: This example demonstrates how to integrate `LocationObserver` with SwiftUI and MapKit for live location tracking.
@Observable class LocationViewModel: LocationObserver {
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3327, longitude: -122.0053),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var locationSubscription: AnyCancellable?

    var locationProvider: LocationProvider {
        return LocationManager.shared
    }

    init() {
        startObservingLocation()
    }

    func handleLocationUpdate(_ location: CLLocation) async {
        self.region.center = location.coordinate
    }
}
