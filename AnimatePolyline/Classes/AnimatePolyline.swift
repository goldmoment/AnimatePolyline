//
//  AnimatePolyline.swift
//  AnimatePolyline
//
//  Created by Vien Van Nguyen on 6/15/20.
//

import GoogleMaps

open class AnimatePolyline {
    private lazy var currentSegment = GMSPolyline()
    private lazy var backgroundSegment = GMSPolyline()
    private lazy var startMarker = GMSMarker()
    private lazy var endMarker = GMSMarker()
    private var totalSteps = 0
    private var totalDuration = 0.0
    private var displaylink: CADisplayLink?
    open var route: [CLLocationCoordinate2D] = [] {
        didSet {
            route.balance(with: 15.0)
            totalSteps = self.route.count
            updateOverlay()
        }
    }
    open var duration: TimeInterval = 3.0
    open var strokeColor: UIColor = .black {
        didSet {
            currentSegment.strokeColor = strokeColor
            backgroundSegment.strokeColor = strokeColor
            startMarker.icon = createStartMaker()
            endMarker.icon = createEndMaker()
        }
    }

    public init(mapView: GMSMapView) {
        makePolylines(mapView: mapView)
        makeMarkers(mapView: mapView)
        displaylink = CADisplayLink(target: self, selector: #selector(step))
    }

    private func updateOverlay() {
        currentSegment.path = route.path
        backgroundSegment.path = route.path
        backgroundSegment.strokeColor = strokeColor

        guard let firstPosition = route.first, let lastPosition = route.last else {
            return
        }
        startMarker.position = firstPosition
        endMarker.position = lastPosition
    }

    private func makePolylines(mapView: GMSMapView) {
        currentSegment = GMSPolyline(path: route.path)
        currentSegment.strokeWidth = 3.0
        currentSegment.strokeColor = strokeColor
        currentSegment.map = mapView

        backgroundSegment = GMSPolyline(path: route.path)
        backgroundSegment.strokeWidth = 3.0
        backgroundSegment.map = mapView
    }

    private func makeMarkers(mapView: GMSMapView) {
        startMarker.icon = createStartMaker()
        startMarker.map = mapView
        startMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        endMarker.icon = createEndMaker()
        endMarker.map = mapView
        endMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }

    open func startAnimation() {
        currentSegment.path = route.path
        backgroundSegment.strokeColor = UIColor.black.withAlphaComponent(0.0)
        displaylink?.add(to: .current, forMode: .defaultRunLoopMode)
    }

    open func pauseAnimation() {
        displaylink?.remove(from: .current, forMode: .defaultRunLoopMode)
    }

    open func stopAnimation() {
        displaylink?.remove(from: .current, forMode: .defaultRunLoopMode)
        currentSegment.path = route.path
        backgroundSegment.strokeColor = .black
    }

    @objc private func step(displaylink: CADisplayLink) {
        let percentage = Float(totalDuration / duration)

        let timingStepValue: Float = Curve.cubic.easeOut(percentage)
        let nextStep: Int = Int(round(timingStepValue.convert(to: 1.0...Float(totalSteps))))

        let timingAlphaValue: Float = Curve.circular.easeIn(percentage)
        let nextAlpha: CGFloat = CGFloat(timingAlphaValue.convert(to: 0.3...1.0))

        // Animation step.
        currentSegment.path = route.suffix(from: nextStep).path
        backgroundSegment.strokeColor = strokeColor.withAlphaComponent(nextAlpha)

        totalDuration = totalDuration + displaylink.duration
        if totalDuration > duration {
            totalDuration = 0.0
        }
    }
}

// MARK: - Utitlities
fileprivate extension AnimatePolyline {
    private func createStartMaker() -> UIImage {
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: 7.5, y: 7.5), radius: 7.5,
                        startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let innerOvalPath = UIBezierPath()
        innerOvalPath.addArc(withCenter: CGPoint(x: 7.5, y: 7.5), radius: 2.0,
                             startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        return UIGraphicsImageRenderer(size: CGSize(width: 15, height: 15)).image { _ in
            self.strokeColor.setFill()
            ovalPath.fill()
            UIColor.white.setFill()
            innerOvalPath.fill()
        }
    }

    private func createEndMaker() -> UIImage {
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 15, height: 15), cornerRadius: 3)
        let innerRectanglePath = UIBezierPath(roundedRect: CGRect(x: 5.5, y: 5.5, width: 4, height: 4), cornerRadius: 0)

        return UIGraphicsImageRenderer(size: CGSize(width: 15, height: 15)).image { _ in
            self.strokeColor.setFill()
            rectanglePath.fill()
            UIColor.white.setFill()
            innerRectanglePath.fill()
        }
    }
}

public extension Array where Element == CLLocationCoordinate2D {
    var path: GMSPath {
        let path = GMSMutablePath()
        self.forEach { path.add($0) }
        return path
    }
}

fileprivate extension ArraySlice where Element == CLLocationCoordinate2D {
    var path: GMSPath {
        let path = GMSMutablePath()
        self.forEach { path.add($0) }
        return path
    }
}

fileprivate extension UIImage {
    func withColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        color.setFill()
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return colored
    }
}
