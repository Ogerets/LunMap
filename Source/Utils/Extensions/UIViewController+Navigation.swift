//
//  UIViewController+Navigation.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/9/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import UIKit

extension UIViewController {
    enum StoryboardName: String {
        case Map
        case BuildingInfo
    }
    
    func initViewController(storyboard: StoryboardName) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()!
        _ = vc.view

        return vc
    }
}
