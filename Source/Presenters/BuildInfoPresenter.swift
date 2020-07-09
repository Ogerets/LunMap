//
//  BuildInfoPresenter.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation

protocol BuildingInfoControllerProtocol: class {
    func setTitle(text: String)
    func setAddress(text: String)
    func setImage(data: Data)
}

class BuildingInfoPresenter {
    weak private var controller: BuildingInfoControllerProtocol?
    private let buildingInfo: BuildingInfo

    init(controller: BuildingInfoControllerProtocol, buildingInfo: BuildingInfo) {
        self.controller = controller
        self.buildingInfo = buildingInfo
    }

    public func updateData() {
        if !self.buildingInfo.title.isEmpty {
            self.controller?.setTitle(text: self.buildingInfo.title)
        }

        if !self.buildingInfo.address.isEmpty {
            self.controller?.setAddress(text: self.buildingInfo.address)
        }

        if let url = URL(string: self.buildingInfo.imageUrl) {
            self.startDownloadImage(from: url)
        }
    }

    private func startDownloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                Log.error(error, message: "Downloading image failed")
            }
            else {
                guard let data = data else {
                    return
                }

                DispatchQueue.main.async {
                    self.controller?.setImage(data: data)
                }
            }
        }.resume()
    }
}

