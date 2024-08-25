//
//  HomeCoordinator.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - HomeRouter
public protocol HomeRouter: AnyObject {
    func routeToProductList(
        categories: [CategoryResponseElement],
        _ from: BaseCoordinator
    )
    
    func routeToCampaignDetail(
        with item: Item,
        _ from: BaseCoordinator
    )
}

// MARK: - HomeCoordinator
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
    final func routeToProductList(with categories: [CategoryResponseElement]) {
        delegate?.routeToProductList(categories: categories, self)
    }
    
    final func routeToCampaignDetail(with item: Item) {
        delegate?.routeToCampaignDetail(with: item, self)
    }
}

