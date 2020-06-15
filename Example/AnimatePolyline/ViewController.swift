//
//  ViewController.swift
//  AnimatePolyline
//
//  Created by viensaigon on 06/15/2020.
//  Copyright (c) 2020 viensaigon. All rights reserved.
//

import UIKit
import GoogleMaps
import AnimatePolyline

class ViewController: UIViewController {
    let camera = GMSCameraPosition.camera(withLatitude: 10.7915928, longitude: 106.6692043, zoom: 16.0)
    lazy var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

    var animatePolyline: AnimatePolyline?

    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.findRouteOnMap(
            pickup: CLLocationCoordinate2D(latitude: 10.8116326, longitude: 106.6727548),
            destination: CLLocationCoordinate2D(latitude: 10.7721148, longitude: 106.6960897)) { [weak self] route in
                guard let route = route else { return }
                self?.makeAnimatePolyline(route: route)
            }
    }

    private func makeAnimatePolyline(route: [CLLocationCoordinate2D]) {
        self.animatePolyline = AnimatePolyline(mapView: self.mapView)
        self.animatePolyline?.route = route
        self.animatePolyline?.startAnimation()
        self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: route.path), withPadding: 50.0))
    }

    override func loadView() {
        view = mapView
    }
}

