//
//  BuildingInfo.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation

/// Represents information about the building
class BuildingInfo {
    let title: String
    let address: String
    let imageUrl: String

    public enum Error: Swift.Error {
        case parsingFeatureFailed
    }

    init(feature: Feature) throws {
        guard
            let title = feature.attributes["name"] as? String,
            let address = feature.attributes["address"] as? String,
            let imageUrlString = feature.attributes["image_url"] as? String
        else {
            throw Error.parsingFeatureFailed
        }

        self.title = title
        self.address = address
        self.imageUrl = imageUrlString
    }
}
