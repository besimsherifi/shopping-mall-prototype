//
//  IndoorMapViewRepresentable.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import SwiftUI
import MapKit
import Unicorn

/// UIViewRepresentable wrapper for MKMapView with Unicorn SDK integration
struct IndoorMapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var isIndoorMode: Bool
    @Binding var userLocation: CLLocationCoordinate2D?
    
    // Shared reference to the most recently created MKMapView
    private static var sharedMapView: MKMapView?
    
    // Class method to get access to the map view from outside
    static func getSharedMapView() -> MKMapView? {
        return sharedMapView
    }
    
    // Coordinator for map interactions
    var coordinator: Coordinator = Coordinator()
    
    // Internal state
    @State private var lastPosition: Position?
    @State private var siteCoordinate: CLLocationCoordinate2D?
    @State private var previousOutdoorRegion: MKCoordinateRegion?
    
    func makeUIView(context: Context) -> MKMapView {
        coordinator.parent = self
        
        let mapView = MKMapView()
        
        // Save reference to this map view for external access
        IndoorMapViewRepresentable.sharedMapView = mapView
        
        // Configure map
        mapView.showsUserLocation = !isIndoorMode
        mapView.delegate = context.coordinator
        mapView.mapType = .standard
        mapView.pointOfInterestFilter = .includingAll
        
        // Register callbacks for Unicorn positioning
        Unicorn.PositioningService.registerStateCallback { state, error in
            DispatchQueue.main.async {
                if state == .idle {
                    // Save current region before switching to indoor mode
                    if self.isIndoorMode {
                        self.previousOutdoorRegion = mapView.region
                    }
                    
                    // Clear device marker and reset state
                    self.updateDeviceMarker(mapView: mapView, position: nil)
                    self.isIndoorMode = false
                    // Show user location when not in indoor mode
                    mapView.showsUserLocation = true
                    // Clear overlays
                    self.clearSite(mapView: mapView)
                    
                    // Animate zoom out to previous outdoor view
                    if let previousRegion = self.previousOutdoorRegion {
                        UIView.animate(withDuration: 2.5, delay: 0.2, options: [.curveEaseInOut], animations: {
                            mapView.setRegion(previousRegion, animated: false)
                        })
                        print("🔙 Zooming out to previous outdoor view")
                    }
                }
                
                if let error = error {
                    print("Positioning error: \(error)")
                }
            }
        }
        
        Unicorn.PositioningService.registerPositionCallback { position in
            DispatchQueue.main.async {
                self.updateDeviceMarker(mapView: mapView, position: position)
                self.userLocation = position.coordinate
                
                // Center map on target REMA coordinates when in indoor mode
                if self.isIndoorMode {
					let targetCoordinate = CLLocationCoordinate2D(latitude: 59.91321, longitude: 10.73614)
                    let camera = MKMapCamera(
                        lookingAtCenter: targetCoordinate,
                        fromDistance: 150, // Increased distance for better overview
                        pitch: 0,
                        heading: 55 // Match the heading from site loading
                    )
                    
                    // Slower, more gradual zoom animation
                    UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
                        mapView.setCamera(camera, animated: false)
                    })
                }
            }
        }
        
        Unicorn.PositioningService.registerSiteCallback { site in
            DispatchQueue.main.async {
                // Save current outdoor region before entering indoor mode
                if let site = site, !self.isIndoorMode {
                    self.previousOutdoorRegion = mapView.region
                    print("💾 Saved outdoor region: \(mapView.region)")
                }
                
                self.updateSite(mapView: mapView, site: site)
                if let site = site {
                    self.isIndoorMode = true
                    mapView.showsUserLocation = false
                    print("Site loaded: \(site.name)")
                }
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update map region if needed (only when not in indoor mode)
        if !isIndoorMode && !uiView.region.center.latitude.isEqual(to: region.center.latitude) {
            uiView.setRegion(region, animated: true)
        }
        
        // Update user location visibility
        uiView.showsUserLocation = !isIndoorMode
    }
    
    // Helper functions
    private func addOverlay(mapView: MKMapView, overlay: Overlay) {
        let mapViewOverlay = IndoorMapImageOverlay(overlay: overlay)
        mapView.addOverlay(mapViewOverlay)
        coordinator.overlays.append(mapViewOverlay)
    }
    
    private func clearOverlays(mapView: MKMapView) {
        mapView.removeOverlays(coordinator.overlays)
        coordinator.overlays.removeAll()
    }
    
    private func clearSite(mapView: MKMapView) {
        clearOverlays(mapView: mapView)
    }
    
    private func updateSite(mapView: MKMapView, site: Unicorn.Site?) {
        siteCoordinate = site?.coordinate
        
        // Pan to site coordinate when available, but prefer user position if available
        if let coordinate = siteCoordinate, CLLocationCoordinate2DIsValid(coordinate) {
            print("Valid site coordinates received: \(coordinate)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Use specific REMA coordinates for consistent centering
				let targetCoordinate = CLLocationCoordinate2D(latitude: 59.91325, longitude: 10.73609)
                
                let camera = MKMapCamera(
                    lookingAtCenter: targetCoordinate,
                    fromDistance: 100, // Slightly pulled back for better overview
                    pitch: 0,
                    heading: 114
                )
                
                // Slower, more gradual zoom animation for site loading
                UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
                    mapView.setCamera(camera, animated: false)
                })
                print("🎯 Camera centered on target coordinates: \(targetCoordinate)")
            }
        }
        
        guard let site = site else {
            clearSite(mapView: mapView)
            return
        }
        
        // Add site overlay if available
        if let overlay = site.overlay {
            addOverlay(mapView: mapView, overlay: overlay)
        }
        
        // Render buildings and floors
        for building in site.buildings {
            for floor in building.floors {
                if let overlay = floor.overlay {
                    addOverlay(mapView: mapView, overlay: overlay)
                }
            }
        }
    }
    
    private func updateDeviceMarker(mapView: MKMapView, position: Position?) {
        lastPosition = position
        
        guard let coordinate = lastPosition?.coordinate else {
            // Remove device annotation if position is nil
            if let deviceAnnotation = coordinator.deviceAnnotation {
                mapView.removeAnnotation(deviceAnnotation)
                coordinator.deviceAnnotation = nil
            }
            return
        }
        
        if let deviceAnnotation = coordinator.deviceAnnotation {
            // Update existing annotation
            UIView.animate(withDuration: 0.2) {
                deviceAnnotation.position = self.lastPosition
                deviceAnnotation.coordinate = coordinate
            }
            
            // Update heading if available
            if let annotationView = mapView.view(for: deviceAnnotation) as? IndoorMapDeviceAnnotationView,
               let deviceHeading = lastPosition?.heading?.magneticHeading {
                annotationView.updateHeading(deviceHeading: deviceHeading, mapHeading: 0)
            }
        } else {
            // Create new annotation
            coordinator.deviceAnnotation = IndoorMapDeviceAnnotation()
            coordinator.deviceAnnotation?.position = lastPosition
            coordinator.deviceAnnotation?.coordinate = coordinate
            coordinator.deviceAnnotation?.renderHeading = true
            
            mapView.addAnnotation(coordinator.deviceAnnotation!)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: IndoorMapViewRepresentable?
        var deviceAnnotation: IndoorMapDeviceAnnotation?
        var overlays: [IndoorMapImageOverlay] = []
        
        // MARK: - MKMapViewDelegate Methods
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let imageOverlay = overlay as? IndoorMapImageOverlay {
                return IndoorMapImageOverlayRenderer(overlay: imageOverlay)
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Keep default blue dot for user location
            if annotation is MKUserLocation {
                return nil
            }
            
            // Handle device annotations
            if let annotation = annotation as? IndoorMapDeviceAnnotation {
                let reuseIdentifier = "IndoorMapDeviceAnnotation"
                
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? IndoorMapDeviceAnnotationView {
                    annotationView.annotation = annotation
                    return annotationView
                } else {
                    let annotationView = IndoorMapDeviceAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                    annotationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                    return annotationView
                }
            }
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Update parent's region binding
            DispatchQueue.main.async {
                self.parent?.region = mapView.region
            }
        }
    }
}
