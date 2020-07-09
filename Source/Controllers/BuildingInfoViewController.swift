//
//  BuildingInfoViewController.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import UIKit

class BuildingInfoViewController: BottomPopupViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    private var presenter: BuildingInfoPresenter!

    func set(presenter: BuildingInfoPresenter) {
        self.presenter = presenter
        self.presenter.updateData()
    }

    // FUTURE: Should probably depend on screen size
    override var popupHeight: CGFloat { return CGFloat(320) }
}

// MARK: - Presenter Protocol Conformance
extension BuildingInfoViewController: BuildingInfoControllerProtocol {
    func setTitle(text: String) {
        self.titleLabel.text = text
    }

    func setAddress(text: String) {
        self.addressLabel.text = text
    }

    func setImage(data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }

        self.imageView.image = image
    }
}
