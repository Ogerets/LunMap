//
//  MapView+Params.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Mapbox

extension MGLMapView {
    func configure(with params: MapViewParams) {
        self.setCenter(params.city.coordinates(),
                       zoomLevel: params.startZoomLevel,
                       animated: false)

        self.maximumZoomLevel = params.maxZoomLevel
        self.minimumZoomLevel = params.minZoomLevel
    }
}
