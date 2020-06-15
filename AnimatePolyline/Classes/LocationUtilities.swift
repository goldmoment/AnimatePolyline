//
//  LocationUtilities.swift
//  AnimatePolyline
//
//  Created by Vien Van Nguyen on 6/15/20.
//

import CoreLocation
import UIKit

internal extension CLLocationCoordinate2D {
    func bearing(with location: CLLocationCoordinate2D) -> Double {
        let fLat = self.latitude.toRadians
        let fLng = self.longitude.toRadians
        let tLat = location.latitude.toRadians
        let tLng = location.longitude.toRadians
        let deltaLng = tLng - fLng

        let y = sin(deltaLng) * cos(tLat)
        let x = cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(deltaLng)

        let bearing = atan2(y, x)

        return bearing.toDegrees
    }

    func coordinates(at distance: Double, and bearing: Double) -> CLLocationCoordinate2D {
        let earthRadius    = 6378.1370
        let distanceRadians = distance * 0.001 / earthRadius
        let bearingRadians = bearing.toRadians
        let fromLatRadians = self.latitude.toRadians
        let fromLonRadians = self.longitude.toRadians

        let toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians) + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians))
        var toLonRadians = fromLonRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians) - sin(fromLatRadians) * sin(toLatRadians));

        toLonRadians = fmod((toLonRadians + 3 * Double.pi), (2 * Double.pi)) - Double.pi

        let lat = toLatRadians.toDegrees
        let lon = toLonRadians.toDegrees

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    func distance(from location: CLLocationCoordinate2D) -> Double {
        let p1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let p2 = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return p1.distance(from: p2)
    }
}

internal extension Array where Element == CLLocationCoordinate2D {
    mutating func balance(with distance: Double = 10) {
        guard self.count > 1 else { return }

        var newArray: [CLLocationCoordinate2D] = []

        for i in 0..<(self.count - 1) {
            var begin = self[i]
            let end = self[i + 1]

            newArray.append(begin)
            while begin.distance(from: end) > distance {
                let bearing = begin.bearing(with: end)
                let newLocation = begin.coordinates(at: distance, and: bearing)
                newArray.append(newLocation)
                begin = newLocation
            }
        }
        newArray.append(self.last!)
        self = newArray
    }
}

internal extension Double {
    var toDegrees: Double {
        return self * 180.0 / Double.pi
    }

    var toRadians: Double {
        return Double.pi * self / 180.0
    }
}

internal extension Double {
    func convert(from range1: ClosedRange<Double> = 0.0...1.0, to range2: ClosedRange<Double>) -> Double {
        let min = range1.lowerBound
        let max = range1.upperBound

        let a = range2.lowerBound
        let b = range2.upperBound

        return (b - a) * ( self - min) / (max - min) + a
    }
}

internal extension Float {
    func convert(from range1: ClosedRange<Float> = 0.0...1.0, to range2: ClosedRange<Float>) -> Float {
        let min = range1.lowerBound
        let max = range1.upperBound

        let a = range2.lowerBound
        let b = range2.upperBound

        return (b - a) * ( self - min) / (max - min) + a
    }
}

