//
//  UIWindow+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit

public extension UIWindow {
    func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        _ completion: (() -> Void)? = nil
    ) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            }
        )
    }
}
