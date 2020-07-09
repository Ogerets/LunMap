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

    private lazy var presenter = MapPresenter(controller: self)

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

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(sender:)))
        self.mapView.addModalGestureRecognizer(singleTap)
    }

    @objc private func handleMapTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: sender.view)

        self.presenter.mapTapped(at: point)
    }
}

extension MapViewController: MapViewControllerProtocol {
    func showBuildingInfo(_ info: BuildingInfo) {
        let buildingInfoView = UIStoryboard(name: "BuildingInfo", bundle: Bundle.main)
        let buildingInfoVC = buildingInfoView.instantiateInitialViewController()! as! BuildingInfoViewController
        _ = buildingInfoVC.view

        buildingInfoVC.setupWith(buildingInfo: info)
        buildingInfoVC.popupDelegate = self

        self.present(buildingInfoVC, animated: true, completion: nil)
    }

    func setCamera(to coordinate: CLLocationCoordinate2D) {
        self.mapView.setCenter(coordinate, zoomLevel: Defaults.viewInfoZoomLevel, animated: true)
    }

    func getBuildingFeatures(in rect: CGRect) -> [Feature] {
        // TODO: Make enum with layers ids
        let mglFeatures = self.mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["buildings"])

        return mglFeatures.map { Feature(coordinates: $0.coordinate, attributes: $0.attributes) }
    }

    func addAnnotation(at coordinates: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinates

        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "buildings", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "buildings", url: url)

        style.addSource(source)

        let layer = MGLCircleStyleLayer(identifier: "buildings", source: source)

        layer.sourceLayerIdentifier = "buildings"
        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.9984138608, green: 0.5949610472, blue: 0.002865632763, alpha: 1))
        layer.circleOpacity = NSExpression(forConstantValue: 1.0)

        let zoomStops = [10: 2,
                         15: 10]
        let format = "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)"
        layer.circleRadius = NSExpression(format: format, zoomStops)

        if let annotationsLayer = mapView.style?.layer(withIdentifier: "com.mapbox.annotations.points") {
            style.insertLayer(layer, below: annotationsLayer)
        }
        else {
            style.addLayer(layer)
        }
    }
}

extension MapViewController: BottomPopupDelegate {
    // TODO: Add to Presenter ?
    func bottomPopupDidDismiss() {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
    }
}

