//
//  IndoorMapImageOverlay.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import CoreGraphics
import CoreLocation
import UIKit
import MapKit
import Unicorn

extension MKCoordinateRegion {
    public var rect : MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: self.center.latitude + (self.span.latitudeDelta/2), longitude: self.center.longitude - (self.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: self.center.latitude - (self.span.latitudeDelta/2), longitude: self.center.longitude + (self.span.longitudeDelta/2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
}

class IndoorMapImageOverlay: NSObject, MKOverlay {
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect
    let drawMapRect: MKMapRect
    let imageMapRect: MKMapRect
    
    var overlay: Overlay
    
    private var imageLoaded: UIImage?
    private var imageLoading: Bool = false
    
    init(overlay: Overlay) {
        self.overlay = overlay
        self.coordinate = overlay.centerCoordinate
        
        let southWestPoint = MKMapPoint(overlay.bounds?.southWest ?? kCLLocationCoordinate2DInvalid)
        let northEastPoint = MKMapPoint(overlay.bounds?.northEast ?? kCLLocationCoordinate2DInvalid)
        
        let flatSouthWestPoint = MKMapPoint(overlay.flatBounds?.southWest ?? kCLLocationCoordinate2DInvalid)
        let flatNorthEastPoint = MKMapPoint(overlay.flatBounds?.northEast ?? kCLLocationCoordinate2DInvalid)

        self.drawMapRect = MKMapRect(
            origin: MKMapPoint(
                x: min(southWestPoint.x, northEastPoint.x),
                y: min(southWestPoint.y, northEastPoint.y)
            ),
            size: MKMapSize(
                width: abs(northEastPoint.x - southWestPoint.x),
                height: abs(northEastPoint.y - southWestPoint.y)
            )
        )
        
        var boundingMapRegion = MKCoordinateRegion(self.drawMapRect)
        boundingMapRegion.span.latitudeDelta *= 2
        boundingMapRegion.span.longitudeDelta *= 2
                
        self.imageMapRect = MKMapRect(
            origin: MKMapPoint(
                x: min(flatSouthWestPoint.x, flatNorthEastPoint.x),
                y: min(flatSouthWestPoint.y, flatNorthEastPoint.y)
            ),
            size: MKMapSize(
                width: abs(flatNorthEastPoint.x - flatSouthWestPoint.x),
                height: abs(flatNorthEastPoint.y - flatSouthWestPoint.y)
            )
        )
        
        self.boundingMapRect = MKMapRect(
            origin: MKMapPoint(
                x: min(self.drawMapRect.origin.x, self.imageMapRect.origin.x),
                y: min(self.drawMapRect.origin.y, self.imageMapRect.origin.y)
            ),
            size: MKMapSize(
                width: max(self.drawMapRect.width, self.imageMapRect.width),
                height: max(self.drawMapRect.height, self.imageMapRect.height)
            )
        )
    }
    
    
    func getOrLoadImage(onDoneLoad: @escaping () -> Void) -> UIImage? {
        if imageLoaded != nil {
            return imageLoaded
        }
        
        guard !imageLoading else { return nil }
        imageLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                if let image = await self.overlay.image() {
                    self.imageLoaded = image
                    
                    onDoneLoad();
                    
                    self.imageLoading = false
                }
            }
        }
        
        return nil
    }
}

class IndoorMapImageOverlayRenderer: MKOverlayRenderer {
    init(overlay: IndoorMapImageOverlay) {
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let overlay = overlay as? IndoorMapImageOverlay else { return }
                
        if let image = overlay.getOrLoadImage(onDoneLoad: self.setNeedsDisplay), let cgImage = image.cgImage {
            let boundingRect = self.rect(for: overlay.boundingMapRect)
            let drawMapRect = self.rect(for: overlay.drawMapRect)
            let imageMapRect = self.rect(for: overlay.imageMapRect)
           
            context.saveGState()

            context.translateBy(x: drawMapRect.midX, y: drawMapRect.midY)
            context.scaleBy(x: 1, y: -1)
            context.rotate(by: -(overlay.overlay.rotation * .pi / 180))
            
            let imageRect = CGRect(x: -imageMapRect.size.width / 2, y: -imageMapRect.size.height / 2,
                                   width: imageMapRect.size.width, height: imageMapRect.size.height)

            context.draw(cgImage, in: imageRect)

            context.restoreGState()
        }
    }
}
