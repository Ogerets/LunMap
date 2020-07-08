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
                               zoomLevel: Defaults.startZoomLevel,
                               animated: false)

        self.mapView.maximumZoomLevel = Defaults.maxZoomLevel
        self.mapView.minimumZoomLevel = Defaults.minZoomLevel

        // Add a single tap gesture recognizer. This gesture requires the built-in
        // MGLMapView tap gestures (such as those for zoom and annotation selection)
        // to fail (this order differs from the double tap above).
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(sender:)))
        for recognizer in self.mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        self.mapView.addGestureRecognizer(singleTap)
    }

    @objc private func handleMapTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        let pointTapped = sender.location(in: sender.view)

        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }

        // FIXME
        let width: CGFloat = 10.0

        let rect = CGRect(x: pointTapped.x - width / 2,
                          y: pointTapped.y - width / 2,
                          width: width,
                          height: width)

        let features = self.mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["buildings"])

        // Pick the first feature (which may be a port or a cluster), ideally selecting
        // the one nearest nearest one to the touch point.
        guard let feature = features.first else {
            return
        }

        // FIXME
        guard
            let title = feature.attributes["name"] as? String,
            let address = feature.attributes["address"] as? String,
            let imageUrlString = feature.attributes["image_url"] as? String
        else {
            return
        }

        // FIXME
        let buildingInfo = try! BuildingInfo(title: title, address: address, imageUrl: imageUrlString)

        self.mapView.setCenter(feature.coordinate, zoomLevel: Defaults.viewInfoZoomLevel, animated: true)

        self.showBuidingInfo(buildingInfo)
    }

    private func showBuidingInfo(_ info: BuildingInfo) {
        let buildingInfoView = UIStoryboard(name: "BuildingInfo", bundle: Bundle.main)
        let buildingInfoVC = buildingInfoView.instantiateInitialViewController()! as! BuildingInfoViewController
        _ = buildingInfoVC.view

        buildingInfoVC.setupWith(buildingInfo: info)

        self.present(buildingInfoVC, animated: true, completion: nil)
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        self.mapView.removeAnnotation(annotation)
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "buildings", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "buildings", url: url)

        style.addSource(source)

        let layer = MGLCircleStyleLayer(identifier: "buildings", source: source)

        layer.sourceLayerIdentifier = "HPC_landmarks-b60kqn"
        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.9984138608, green: 0.5949610472, blue: 0.002865632763, alpha: 1))
        layer.circleOpacity = NSExpression(forConstantValue: 1.0)

        let zoomStops = [10: 2,
                         15: 10]
        let format = "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)"
        layer.circleRadius = NSExpression(format: format, zoomStops)

        style.addLayer(layer)
    }
}

