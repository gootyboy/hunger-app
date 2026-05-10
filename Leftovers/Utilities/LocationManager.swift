import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var userLocation: CLLocation?
    var userAddress = ""
    var userCity = ""
    var userState = ""
    var userZip = ""
    var userCountry = ""
    
    var isLoading = false
    var errorMsg: String?
    
    private var hasRequestedLocation = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        isLoading = true
        errorMsg = nil
        
        let status = manager.authorizationStatus
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            requestOneShotLocation()
            
        } else if status == .denied || status == .restricted {
            errorMsg = "Location permission denied"
            isLoading = false
            
        } else {
            isLoading = false
        }
    }
    
    private func requestOneShotLocation() {
        if hasRequestedLocation { return }
        hasRequestedLocation = true
        manager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            hasRequestedLocation = false
            DispatchQueue.main.async {
                self.requestOneShotLocation()
            }
            
        } else if status == .denied || status == .restricted {
            errorMsg = "Location permission denied"
            isLoading = false
            
        } else if status == .notDetermined {
            
        } else {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            isLoading = false
            return
        }
        
        userLocation = location
        
        Task {
            await reverseGeocode(location)
            await MainActor.run {
                self.isLoading = false
                self.hasRequestedLocation = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMsg = error.localizedDescription
        isLoading = false
        hasRequestedLocation = false
    }
    
    private func reverseGeocode(_ location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else {
                await MainActor.run {
                    self.errorMsg = "No address found"
                }
                return
            }
            
            await MainActor.run {
                self.userAddress = placemark.thoroughfare ?? ""
                self.userCity = placemark.locality ?? ""
                self.userState = placemark.administrativeArea ?? ""
                self.userZip = placemark.postalCode ?? ""
                self.userCountry = placemark.country ?? ""
            }
            
        } catch {
            await MainActor.run {
                self.errorMsg = "Geocoding failed: \(error.localizedDescription)"
            }
        }
    }
}
