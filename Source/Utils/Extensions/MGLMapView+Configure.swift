//
//  MGLMapView.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation
import Mapbox

extension MGLMapView {
    func addModalGestureRecognizer(_ newRecognizer: UITapGestureRecognizer) {
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers where recognizer is UITapGestureRecognizer {
                newRecognizer.require(toFail: recognizer)
            }
        }

        self.addGestureRecognizer(newRecognizer)
    }
}

