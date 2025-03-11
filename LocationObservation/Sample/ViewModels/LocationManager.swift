//
//  LocationManager.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 6/22/24.
//

import SwiftUI
import CoreLocation
import Combine

/// An example implementation of `LocationProvider`.
///
/// `LocationManager` utilizes `CLLocationManager` to provide real-time location data to subscribers
/// through a Combine publisher. It maintains the current location and updates observers whenever
/// new location data is available.
///
/// - Note: This example does **not** include error handling for cases where location permissions
///   are denied or restricted. End users should implement proper error handling as needed.
@Observable class LocationManager: NSObject, LocationProvider {
    private var userLocation: CLLocation?
    private var authorizationStatus: CLAuthorizationStatus?

    private let locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject<CLLocation, Never>()

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }

    static let shared = LocationManager()

    var currentLocation: CLLocation? {
        return userLocation
    }

    override init() {
        super.init()
        locationManager.delegate = self
        checkAuthorizationStatus()
    }

    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        authorizationStatus = status

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        Task { @MainActor in
            userLocation = location
            locationSubject.send(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            authorizationStatus = status

            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            } else {
                // Handle cases where location access is denied or restricted
                return
            }
        }
    }
}
