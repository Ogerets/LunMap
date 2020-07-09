//
//  MapViewParams.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation

class MapViewParams {
    var city: City = Defaults.city
    var startZoomLevel: Double = Defaults.startZoomLevel
    var maxZoomLevel: Double = Defaults.maxZoomLevel
    var minZoomLevel: Double = Defaults.minZoomLevel
}
