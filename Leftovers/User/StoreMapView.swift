import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct StoreMarker: Identifiable {
    let id = UUID()
    let store: Store
    let coordinate: CLLocationCoordinate2D
}

struct StoreMapView: View {
    @Query var stores: [Store]
    @State private var mapMarkers: [StoreMarker] = []
    
    // 1. ADDED: State to track whether the map is currently in 3D mode
    @State private var is3DMode: Bool = false
    
    // 2. ADDED: Camera position tracking to automatically tilt the viewpoint when going 3D
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main Map Instance
            Map(position: $position) {
                ForEach(mapMarkers) { marker in
                    Marker(
                        marker.store.name,
                        systemImage: "storefront.fill",
                        coordinate: marker.coordinate
                    )
                    .tint(.blue)
                }
            }
            // 3. FIXED: Dynamically toggle the map style elevation setting
            .mapStyle(.standard(elevation: is3DMode ? .realistic : .flat))
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .ignoresSafeArea(edges: .bottom)
            
            // 4. ADDED: Clean, professional floating 3D/2D Toggle Action Button
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    is3DMode.toggle()
                    
                    // If switching to 3D, tilt the camera slightly to make 3D building models visible
                    if is3DMode, let firstMarker = mapMarkers.first {
                        position = .camera(
                            MapCamera(
                                centerCoordinate: firstMarker.coordinate,
                                distance: 1000,  // Meters above ground level
                                heading: 0,      // Facing North
                                pitch: 45        // 45-degree angle tilt to reveal 3D structures
                            )
                        )
                    } else {
                        // Reset camera position to wrap all markers automatically in flat mode
                        position = .automatic
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: is3DMode ? "square.2d" : "cube.transparent.fill")
                        .font(.body.weight(.bold))
                    Text(is3DMode ? "2D" : "3D")
                        .font(.footnote.weight(.bold))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(.ultraThinMaterial) // Gives a premium glass look
                .foregroundStyle(.blue)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 16)
            .padding(.top, 16) // Places it elegantly at the top right corner of the map layer
        }
        .navigationTitle("Store Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await geocodeStores()
            }
        }
        .onChange(of: stores) { oldValue, newValue in
            Task {
                await geocodeStores()
            }
        }
    }
    
    private func geocodeStores() async {
        let geocoder = CLGeocoder()
        var tempMarkers: [StoreMarker] = []
        
        for store in stores {
            let fullAddress = "\(store.address), \(store.city), \(store.state) \(store.zipCode), \(store.country)"
            
            do {
                let placemarks = try await geocoder.geocodeAddressString(fullAddress)
                
                if let coordinate = placemarks.first?.location?.coordinate {
                    let marker = StoreMarker(store: store, coordinate: coordinate)
                    tempMarkers.append(marker)
                }
            } catch {
                print("Skipping map placement for \(store.name): \(error.localizedDescription)")
            }
        }
        
        self.mapMarkers = tempMarkers
    }
}
