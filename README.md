# LocationObservation  

**LocationObservation** demonstrates how Combine publishers enable real-time data updates between classes in a SwiftUI app, using location as an example while showcasing a pattern applicable to other data types.  

https://github.com/user-attachments/assets/8cd010eb-3931-421d-b921-417199eeb5f6

## Features  
✅ Uses Combine to publish real-time data updates  
✅ Demonstrates observer-based architecture  
✅ Example implementation with location data  
✅ Adaptable to other data types and use cases  

## Usage  
### Defining a Data Provider  
`LocationProvider` manages and publishes location updates using Combine:  

```swift
@Observable class LocationManager: NSObject, LocationProvider {
    private var locationSubject = PassthroughSubject<CLLocation, Never>()
    var locationPublisher: AnyPublisher<CLLocation, Never> { locationSubject.eraseToAnyPublisher() }
}
```

### Observing Data Updates  
`LocationObserver` subscribes to updates and reacts accordingly:  

```swift
class LocationViewModel: LocationObserver {
    @Published var region: MKCoordinateRegion = ...

    func handleLocationUpdate(_ location: CLLocation) async {
        region.center = location.coordinate
    }
}
```
