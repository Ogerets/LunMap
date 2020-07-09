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

    public func setupWith(buildingInfo: BuildingInfo) {
        if !buildingInfo.title.isEmpty {
            self.titleLabel.text = buildingInfo.title
        }

        if !buildingInfo.address.isEmpty {
            self.addressLabel.text = buildingInfo.address
        }

        // FIXME
        if
            let url = URL(string: buildingInfo.imageUrl),
            let data = try? Data(contentsOf: url)
        {
            self.imageView.image = UIImage(data: data)
        }
    }

    override var popupHeight: CGFloat { return CGFloat(300) }

    override var popupTopCornerRadius: CGFloat { return CGFloat(10) }

    override var popupPresentDuration: Double { return 0.2 }

    override var popupDismissDuration: Double { return 0.2 }

    override var popupShouldDismissInteractivelty: Bool { return true }

    override var popupDimmingViewAlpha: CGFloat { return 0 }
}
