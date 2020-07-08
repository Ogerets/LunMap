//
//  Cities.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation
import CoreLocation

enum Cities {
    case Kyiv

    func coordinates() -> CLLocationCoordinate2D {
        switch self {
        case .Kyiv:
            return CLLocationCoordinate2D(latitude: 50.45466, longitude: 30.5238)
        }
    }
}
