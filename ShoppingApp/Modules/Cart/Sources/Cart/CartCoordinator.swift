//
//  CartCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - CartRouter
public protocol CartRouter: AnyObject {
    func routeToProductDetailSummary(
        with data: ProductResponseElement,
        _ from: BaseCoordinator
    )
    
    func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)?,
        _ from: BaseCoordinator
    )
}

// MARK: - CartCoordinator
final public class CartCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: CartRouter?

    // MARK: - Start
    public override func start() {
        let controller = CartViewController(
            viewModel: CartViewModel(),
            coordinator: self
        )

        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
    final func routeToProductDetailSummary(with data: ProductResponseElement) {
        delegate?.routeToProductDetailSummary(with: data, self)
    }
    
    final func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)? = nil
    ) {
        delegate?.routeToProductDetail(
            productID: productID,
            products: products,
            onScreenDismiss: onScreenDismiss,
            self
        )
    }
}
