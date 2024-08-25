//
//  SplashCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit
import Base

// MARK: - SplashRouter
public protocol SplashRouter: AnyObject {
    func routeToSignIn(_ from: BaseCoordinator)
    func routeToOnboarding(_ from: BaseCoordinator)
}

// MARK: - SplashCoordinator
final public class SplashCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: SplashRouter?

    // MARK: - Start
    public override func start() {
        let controller = SplashViewController(coordinator: self)

        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
    final func routeToSignIn() {
        delegate?.routeToSignIn(self)
    }
    
    final func routeToOnboarding() {
        delegate?.routeToOnboarding(self)
    }
}
