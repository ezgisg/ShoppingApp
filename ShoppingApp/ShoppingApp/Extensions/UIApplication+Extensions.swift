//
//  UIApplication+Extensions.swift
//  ShoppingApp
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation
import UIKit

///To find topVC
public extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13, *) {
            guard
                let window = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .map({ $0 as? UIWindowScene })
                    .compactMap({ $0 })
                    .first?.windows
                    .first(where: { $0.isKeyWindow })
            else {
                return UIWindow.key
            }
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    class func topViewController(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


