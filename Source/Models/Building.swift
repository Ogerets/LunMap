//
//  Building.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation

class BuildingInfo {
    let title: String
    let address: String
    let imageUrl: URL

    init(title: String, address: String, imageUrl: String) throws {
        self.title = title
        self.address = address

        guard let imageUrl = URL(string: imageUrl) else {
            // FIXME
            throw NSError()
        }

        self.imageUrl = imageUrl
    }
}
