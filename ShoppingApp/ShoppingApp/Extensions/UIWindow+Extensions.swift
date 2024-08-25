//
//  UIWindow+Extensions.swift
//  ShoppingApp
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation
import UIKit

public extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first { $0.isKeyWindow }
            }
            return nil
        } else {
            return UIApplication.shared.keyWindow
        }
    }
//
//    func switchRootViewController(
//        to viewController: UIViewController,
//        animated: Bool = true,
//        duration: TimeInterval = 0.5,
//        options: UIView.AnimationOptions = .transitionCrossDissolve,
//        _ completion: (() -> Void)? = nil
//    ) {
//        guard animated else {
//            rootViewController = viewController
//            completion?()
//            return
//        }
//
//        UIView.transition(
//            with: self,
//            duration: duration,
//            options: options,
//            animations: {
//                let oldState = UIView.areAnimationsEnabled
//                UIView.setAnimationsEnabled(false)
//                self.rootViewController = viewController
//                UIView.setAnimationsEnabled(oldState)
//            }, completion: { _ in
//                completion?()
//            }
//        )
//    }
}
