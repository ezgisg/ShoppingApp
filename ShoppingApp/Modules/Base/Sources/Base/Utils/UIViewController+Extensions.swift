//
//  UIViewController+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit.UIViewController

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController,
                  navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController,
                  tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
