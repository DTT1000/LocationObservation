//
//  LocationProvider.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 9/3/24.
//

import SwiftUI
import CoreLocation
import Combine

/// A protocol defining a provider that supplies location updates using Combine publishers.
///
/// `LocationProvider` is intended to be applied to a class responsible for handling and delivering
/// location updates to `LocationObservers`. It leverages `CLLocationManagerDelegate` to manage
/// location updates and provides a Combine publisher for reactive event handling.
///
/// - The `locationPublisher` property emits continuous location updates as `CLLocation` values.
/// - The `currentLocation` property provides the most recent known location, if available.
///
/// - Note: Classes conforming to this protocol must properly configure and request location permissions
///   from `CLLocationManager` to ensure accurate and timely location updates.
@MainActor public protocol LocationProvider: NSObject, CLLocationManagerDelegate, Sendable {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    var currentLocation: CLLocation? { get }
}
