//
//  BaseCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit

// MARK: - BaseCoordinator
open class BaseCoordinator: NSObject, Coordinator {
    // MARK: - Publics
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?
    public var navigationController = UINavigationController()

    // MARK: - Init
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    // MARK: - Start
    open func start() {
        fatalError("\(#function) should be implemented.")
    }

    // MARK: - Generic Methods
    public func back() {
        if let controller = navigationController.visibleViewController,
           controller.isModal {
            controller.dismiss(animated: true, completion: nil)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
    
    public func pushWithTransition(
        _ viewController: UIViewController,
        duration: CFTimeInterval = 0.5,
        type: CATransitionType = .fade,
        subtype: CATransitionSubtype? = nil,
        timingFunction: CAMediaTimingFunctionName? = .easeInEaseOut
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subtype
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction ?? .easeInEaseOut)
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    public func setWithTransition(
        _ viewController: UIViewController,
        duration: CFTimeInterval = 0.5,
        type: CATransitionType = .fade,
        subtype: CATransitionSubtype? = nil,
        timingFunction: CAMediaTimingFunctionName? = .easeInEaseOut
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subtype
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction ?? .easeInEaseOut)
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
