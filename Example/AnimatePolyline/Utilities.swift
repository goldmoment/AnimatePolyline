//
//  Utilities.swift
//  AnimatePolyline_Example
//
//  Created by Vien Van Nguyen on 6/15/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import MapKit

class Utilities {
    static func findRouteOnMap(pickup: CLLocationCoordinate2D,
                        destination: CLLocationCoordinate2D,
                        onCompleted: @escaping ([CLLocationCoordinate2D]?)->()) {

        let sourcePlacemark = MKPlacemark(coordinate: pickup, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate { (response, error) in
            onCompleted(response?.routes.first?.polyline.coordinates)
        }
    }
}

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
