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

        // TODO: add configuration method to mapView
        self.mapView.setCenter(Defaults.city.coordinates(),
                               zoomLevel: Defaults.zoomLevel,
                               animated: false)

        self.mapView.maximumZoomLevel = Defaults.maxZoomLevel
        self.mapView.minimumZoomLevel = Defaults.minZoomLevel
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "buildings", ofType: "geojson")!)

        let source = MGLShapeSource(identifier: "buildings",
                                    url: url)

        style.addSource(source)

        let layer = MGLCircleStyleLayer(identifier: "landmarks", source: source)
        layer.sourceLayerIdentifier = "HPC_landmarks-b60kqn"
        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.67, green: 0.28, blue: 0.13, alpha: 1))
        layer.circleOpacity = NSExpression(forConstantValue: 0.8)

        let zoomStops = [10: 2,
                         15: 10]
        let format = "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)"
        layer.circleRadius = NSExpression(format: format, zoomStops)

        style.addLayer(layer)
    }
}

