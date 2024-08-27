//
//  SignInCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - SignInRouter
public protocol SignInRouter: AnyObject {
    func routeToTabBar(_ from: BaseCoordinator)
}

// MARK: - SignInCoordinator
final public class SignInCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: SignInRouter?

    // MARK: - Start
    public override func start() {
        let controller = SignInViewController(
            coordinator: self,
            viewModel: SignInViewModel()
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
    
    final func routeToRegister() {
        let viewController = RegisterViewController(
            viewModel: RegisterViewModel(),
            coordinator: self
        )
        
        pushWithTransition(viewController)
    }
}
