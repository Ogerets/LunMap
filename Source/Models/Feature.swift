//
//  Feature.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import CoreLocation

/// Represents any feature on map
class Feature {
    let coordinates: CLLocationCoordinate2D
    let attributes: [String: Any]

    init(coordinates: CLLocationCoordinate2D, attributes: [String: Any]) {
        self.coordinates = coordinates
        self.attributes = attributes
    }
}
