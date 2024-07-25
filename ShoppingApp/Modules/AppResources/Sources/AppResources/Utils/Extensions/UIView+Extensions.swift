//
//  UIView+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import Foundation
import UIKit

public extension UIView {
    func fadeIn(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    func fadeOut(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
