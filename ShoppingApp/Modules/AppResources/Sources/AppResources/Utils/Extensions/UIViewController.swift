//
//  UIViewController.swift
//
//
//  Created by Ezgi Sümer Günaydın on 31.07.2024.
//

import Foundation
import UIKit

public extension UIViewController {
    
    func pushWithTransition(_ viewController: UIViewController, duration: CFTimeInterval = 0.5, type: CATransitionType = .fade, subtype: CATransitionSubtype? = nil, timingFunction: CAMediaTimingFunctionName? = .easeInEaseOut) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subtype
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction ?? .easeInEaseOut)
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func setWithTransition(_ viewController: UIViewController, duration: CFTimeInterval = 0.5, type: CATransitionType = .fade, subtype: CATransitionSubtype? = nil, timingFunction: CAMediaTimingFunctionName? = .easeInEaseOut) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subtype
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction ?? .easeInEaseOut)
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.setViewControllers([viewController], animated: false)
    }
}


