//
//  HomeCoordinator.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit
import Base

public protocol HomeRouter: AnyObject {
    func routeToProductList(_ from: BaseCoordinator)
}

// MARK: - SplashCoordinator
final public class HomeCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: HomeRouter?

    // MARK: - Start
    public override func start() {
        let controller = HomeViewController(
            coordinator: self,
            viewModel: HomeViewModel()
        )

        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
}

