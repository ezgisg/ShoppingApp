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
        categories: [CategoryResponseElement] = [],
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
    final public func routeToProductDetailSummary(with data: ProductResponseElement) {
        let detailBottomVC = DetailBottomViewController(
            product: data,
            viewModel: DetailBottomViewModel(),
            coordinator: self
        )
        detailBottomVC.modalPresentationStyle = .overFullScreen
        detailBottomVC.modalTransitionStyle = .crossDissolve
        navigationController.present(detailBottomVC, animated: true, completion: nil)
    }
    
    
    final public func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)? = nil
    ) {
        let detailProductVC = ProductDetailViewController(
            productID: productID,
            products: products,
            viewModel: DetailBottomViewModel(),
            coordinator: self,
            onScreenDismiss: onScreenDismiss
        )
        detailProductVC.modalPresentationStyle = .overFullScreen
        detailProductVC.modalTransitionStyle = .crossDissolve
        
        var topController: UIViewController = navigationController

        while let presentedVC = topController.presentedViewController {
            topController = presentedVC
        }
        topController.present(detailProductVC, animated: true, completion: nil)
    }
}

