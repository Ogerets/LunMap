//
//  MapViewController.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupMapView()
    }

    private func setupMapView() {
        self.mapView.delegate = self
        self.mapView.latitude = Defaults.city.coordinates().latitude
        self.mapView.longitude = Defaults.city.coordinates().longitude
        self.mapView.zoomLevel = Defaults.zoomLevel
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // TODO
    }
}

