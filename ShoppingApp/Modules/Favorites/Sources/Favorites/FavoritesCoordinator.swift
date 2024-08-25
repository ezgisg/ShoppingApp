//
//  FavoritesCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - FavoritesRouter
public protocol FavoritesRouter: AnyObject {
    func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)?,
        _ from: BaseCoordinator
    )
    
    func routeToProductDetailSummary(
        with data: ProductResponseElement,
        _ from: BaseCoordinator
    )
}


// MARK: - FavoritesCoordinator
final public class FavoritesCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: FavoritesRouter?
    
    // MARK: - Start
    public override func start() {
        let controller = FavoritesViewController(
            coordinator: self
        )
        
        navigationController.setViewControllers([controller], animated: true)
    }
    
    // MARK: - Routing Methods
    final func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)?
    ) {
        delegate?.routeToProductDetail(
            productID: productID,
            products: products,
            onScreenDismiss: onScreenDismiss,
            self
        )
    }
    
    final func routeToProductDetailSummary(with data: ProductResponseElement) {
        delegate?.routeToProductDetailSummary(with: data, self)
    }
}
