//
//  LocationObserver.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 9/3/24.

import SwiftUI
import CoreLocation
import Combine

/// A protocol defining an observer that listens for location updates from a `LocationProvider`.
///
/// `LocationObserver` is designed to be implemented by classes that need to react to location updates
/// in real time. It subscribes to a `LocationProvider`'s publisher and asynchronously handles
/// new location data as it is received.
///
/// - The `locationProvider` supplies location updates via a Combine publisher.
/// - The `locationSubscription` stores the active subscription to prevent premature deallocation.
/// - The `handleLocationUpdate(_:)` method must be implemented to define how location updates are processed.
///
/// - Note: Classes conforming to this protocol should call `startObservingLocation()` to begin receiving updates
///   and `stopObservingLocation()` to clean up resources when no longer needed.
@MainActor public protocol LocationObserver: AnyObject, Sendable {
    var locationProvider: LocationProvider { get }
    var locationSubscription: AnyCancellable? { get set }
    func handleLocationUpdate(_ location: CLLocation) async
}

public extension LocationObserver {
    /// Starts observing location updates from the `locationProvider`.
    ///
    /// This method subscribes to the location publisher and listens for updates. When a new
    /// location is received, it triggers `handleLocationUpdate(_:)` asynchronously.
    func startObservingLocation() {
        locationSubscription = locationProvider.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                Task { @MainActor in
                    await self.handleLocationUpdate(location)
                }
            }
    }

    /// Stops observing location updates by canceling the subscription.
    ///
    /// This method should be called when the observer is no longer needed
    /// to prevent unnecessary resource usage.
    func stopObservingLocation() {
        locationSubscription = nil
    }

    /// Requests the most recent location from the `locationProvider`.
    ///
    /// If a current location is available, this method immediately passes it to `handleLocationUpdate(_:)`.
    /// Otherwise, no action is taken.
    ///
    /// - Note: This method does not initiate a new location request but retrieves the last known location.
    func requestCurrentLocation() async {
        guard let currentLocation = locationProvider.currentLocation else { return }
        await handleLocationUpdate(currentLocation)
    }
}
