//
//  IndoorMapDeviceAnnotation.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import MapKit
import UIKit
import Unicorn

class IndoorMapDeviceAnnotation: MKPointAnnotation {
    var position: Position?
    var renderHeading: Bool = false
}

class IndoorMapDeviceAnnotationView: MKAnnotationView {
    
    private var deviceHeading: Double? = nil
    private var mapHeading: Double = 0.0
    
    var heading: Double? = nil {
        didSet {
            deviceHeading = heading
            updateRotation()
            
            if oldValue == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    // Update the heading taking map rotation into account
    func updateHeading(deviceHeading: Double, mapHeading: Double) {
        let oldDeviceHeading = self.deviceHeading
        let oldMapHeading = self.mapHeading
        
        self.deviceHeading = deviceHeading
        self.mapHeading = mapHeading
        
        // Only update if there's a meaningful change to avoid unnecessary redraws
        // This is especially important during continuous map rotation
        if oldDeviceHeading != deviceHeading || 
           abs(oldMapHeading - mapHeading) > 0.5 {
            updateRotation()
            // Only force redraw if heading is actually being displayed
            if let annotation = self.annotation as? IndoorMapDeviceAnnotation, 
               annotation.renderHeading {
                self.setNeedsDisplay()
            }
        }
    }
    
    // Calculate rotation based on device heading and map heading
    private func updateRotation() {
        if let deviceHeading = self.deviceHeading {
            // Adjust device heading by subtracting map heading to maintain proper orientation
            let adjustedHeading = deviceHeading - mapHeading
            let angle = adjustedHeading * .pi / 180
            self.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
        
    override func draw(_ rect: CGRect) {
        guard let annotation = self.annotation as? IndoorMapDeviceAnnotation, let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        let circleRadius = CGFloat(15 / 2)

        if annotation.renderHeading && self.deviceHeading != nil {
            drawHeading(rect, context: context)
        }
        
        drawPosition(rect, context: context, radius: circleRadius)
    }
    
    func drawHeading(_ rect: CGRect, context: CGContext) {
        let headingConeHeight: CGFloat = 40
        let headingConeWidth: CGFloat = 35
        
        let headingConeCenter = CGPoint(x: rect.midX, y: rect.midY)
        let headingConeLeftEnd = CGPoint(x: headingConeCenter.x - headingConeWidth / 2, y: headingConeCenter.y - headingConeHeight)
        let headingConeRightEnd = CGPoint(x: headingConeCenter.x + headingConeWidth / 2, y: headingConeCenter.y - headingConeHeight)
        
        let headingPath = UIBezierPath()
        headingPath.move(to: headingConeCenter)
        headingPath.addLine(to: headingConeLeftEnd)
        headingPath.addLine(to: headingConeRightEnd)
        headingPath.close()
                
        let colors = [UIColor.systemBlue.withAlphaComponent(0.8).cgColor, UIColor.systemBlue.withAlphaComponent(0).cgColor]
        let colorLocations: [CGFloat] = [0.0, 0.9]
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: colorLocations)
        
        context.saveGState()
        
        context.addPath(headingPath.cgPath)
        context.clip()

        context.drawLinearGradient(gradient!, start: CGPoint(x: headingConeCenter.x, y: headingConeCenter.y), end: CGPoint(x: headingConeCenter.x, y: headingConeRightEnd.y), options: .drawsBeforeStartLocation)
        
        context.restoreGState()
    }
    
    func drawPosition(_ rect: CGRect, context: CGContext, radius: CGFloat) {
        let circleRect = CGRect(x: rect.midX - radius, y: rect.midY - radius, width: CGFloat(radius * 2), height: CGFloat(radius * 2))
        
        context.setShadow(offset: CGSize.zero, blur: 4, color: UIColor.black.cgColor)
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokeEllipse(in: circleRect)
        context.setShadow(offset: CGSize.zero, blur: 0, color: UIColor.clear.cgColor)
        
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fillEllipse(in: circleRect)
        
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokeEllipse(in: circleRect)
    }
}
