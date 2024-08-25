//
//  OnboardingCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - OnboardingRouter
public protocol OnboardingRouter: AnyObject {
    func routeToTabBar(_ from: BaseCoordinator)
    func routeToSignIn(_ from: BaseCoordinator)
}

// MARK: - OnboardingCoordinator
final public class OnboardingCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: OnboardingRouter?

    // MARK: - Start
    public override func start() {
        let controller = OnboardingViewController(
            coordinator: self
        )
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
    final func routeToTabBar() {
        delegate?.routeToTabBar(self)
    }
    
    final func routeToSignIn() {
        delegate?.routeToSignIn(self)
    }
}
