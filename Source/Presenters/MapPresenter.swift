//
//  MapPresenter.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import CoreGraphics
import CoreLocation

protocol MapViewControllerProtocol: class {
    func getBuildingFeatures(in rect: CGRect) -> [Feature]
    func showBuildingInfo(_ info: BuildingInfo)
    func setCamera(to coordinate: CLLocationCoordinate2D)
    func addAnnotation(at coorditate: CLLocationCoordinate2D)
    func removeAnnotations()
}

class MapPresenter {
    weak private var controller: MapViewControllerProtocol?

    init(controller: MapViewControllerProtocol) {
        self.controller = controller
    }

    func mapTapped(at point: CGPoint) {
        do {
            // FUTURE: adjust according to zoom level
            let searchEdge: CGFloat = 10.0

            let searchRect = CGRect(x: point.x - searchEdge / 2,
                                    y: point.y - searchEdge / 2,
                                    width: searchEdge,
                                    height: searchEdge)

            guard let features = self.controller?.getBuildingFeatures(in: searchRect) else {
                return
            }

            // FUTURE: Pick the closest to tap
            guard let feature = features.first else {
                return
            }

            let buildingInfo = try BuildingInfo(feature: feature)

            self.controller?.setCamera(to: feature.coordinates)
            self.controller?.showBuildingInfo(buildingInfo)
            self.controller?.addAnnotation(at: feature.coordinates)
        }
        catch {
            Log.error(error, message: "Failed map tap")
        }
    }

    func buildingInfoViewDidDismiss() {
        self.controller?.removeAnnotations()
    }
}
