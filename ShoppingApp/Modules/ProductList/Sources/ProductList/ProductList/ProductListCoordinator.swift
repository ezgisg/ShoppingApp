//
//  ProductListCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - ProductListRouter
public protocol ProductListRouter: AnyObject {
}

// MARK: - ProductListCoordinator
final public class ProductListCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: ProductListRouter?
    
    // MARK: - Private Variables
    private var categories: [CategoryResponseElement]
    
    // MARK: - Init
    public init(
        categories: [CategoryResponseElement],
        _ navigationController: UINavigationController
    ) {
        self.categories = categories
        super.init(navigationController)
    }

    // MARK: - Start
    public override func start() {
        let controller = ProductListViewController(
            viewModel: ProductListViewModel(categories: categories), 
            coordinator: self
        )

        navigationController.pushViewController(controller, animated: true)
    }

    // MARK: - Routing Methods
}

