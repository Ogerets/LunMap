//
//  MapViewController.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

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
        self.mapView.configure(with: MapViewParams())

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(sender:)))
        self.mapView.addModalGestureRecognizer(singleTap)
    }

    @objc private func handleMapTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: sender.view)

        self.presenter.mapTapped(at: point)
    }
}

// MARK: - Presenter Protocol Conformance
extension MapViewController: MapViewControllerProtocol {
    func getBuildingFeatures(in rect: CGRect) -> [Feature] {
        self.mapView
            .visibleFeatures(in: rect, styleLayerIdentifiers: [StyleLayerId.buildings.rawValue])
            .map { Feature(coordinates: $0.coordinate, attributes: $0.attributes) }
    }

    func showBuildingInfo(_ info: BuildingInfo) {
        let buildingInfoVC = self.initViewController(storyboard: .buildingInfo) as! BuildingInfoViewController
        let presenter = BuildingInfoPresenter(controller: buildingInfoVC, buildingInfo: info)
        buildingInfoVC.set(presenter: presenter)
        buildingInfoVC.popupDelegate = self

        self.present(buildingInfoVC, animated: true, completion: nil)
    }

    func setCamera(to coordinate: CLLocationCoordinate2D) {
        let camera = MGLMapCamera(lookingAtCenter: coordinate, altitude: 4500, pitch: 0, heading: 0)

        let animationFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.mapView.setCamera(camera, withDuration: 1, animationTimingFunction: animationFunction)
    }

    func addAnnotation(at coordinates: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinates

        self.mapView.addAnnotation(annotation)
    }

    func removeAnnotations() {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
    }
}

// MARK: - Mapbox Delegate
extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // FUTURE: can be loaded from mapbox server as tileset
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "buildings", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "buildings", url: url)
        style.addSource(source)

        let layer = self.makeBuildingsLayer(from: source)

        if let annotationsLayer = mapView.style?.layer(withIdentifier: "com.mapbox.annotations.points") {
            style.insertLayer(layer, below: annotationsLayer)
        }
        else {
            style.addLayer(layer)
        }
    }

    private func makeBuildingsLayer(from source: MGLShapeSource) -> MGLCircleStyleLayer {
        let layer = MGLCircleStyleLayer(identifier: StyleLayerId.buildings.rawValue, source: source)
        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.9984138608, green: 0.5949610472, blue: 0.002865632763, alpha: 1))

        let zoomStops = [10: 2, 15: 10]
        let format = "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)"
        layer.circleRadius = NSExpression(format: format, zoomStops)

        return layer
    }
}

// MARK: - Bottom Popup Delegate
extension MapViewController: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        self.presenter.buildingInfoViewDidDismiss()
    }
}
