//
//  CategoriesCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - CategoriesRouter
public protocol CategoriesRouter: AnyObject {
    func routeToProductList(
        categories: [CategoryResponseElement],
        _ from: BaseCoordinator
    )
}

// MARK: - CategoriesCoordinator
final public class CategoriesCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: CategoriesRouter?

    // MARK: - Start
    public override func start() {
        let controller = CategoriesViewController(
            coordinator: self,
            viewModel: CategoriesViewModel()
        )

        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
    final func routeToProductList(with categories: [CategoryResponseElement]) {
        delegate?.routeToProductList(categories: categories, self)
    }
}
