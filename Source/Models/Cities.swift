//
//  Cities.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import CoreLocation

/// Describes available cities with default coordiinates
enum City {
    case kyiv

    func coordinates() -> CLLocationCoordinate2D {
        switch self {
        case .kyiv:
            return CLLocationCoordinate2D(latitude: 50.45466, longitude: 30.5238)
        }
    }
}
