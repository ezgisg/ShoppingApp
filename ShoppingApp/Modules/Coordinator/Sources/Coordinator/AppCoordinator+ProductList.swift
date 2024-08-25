//
//  AppCoordinator+Home.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import AppResources
import Foundation
import Base
import ProductList

public extension AppCoordinator {
    func routeToProductList(
        categories: [CategoryResponseElement],
        _ from: BaseCoordinator
    ) {
        let coordinator = ProductListCoordinator(
            categories: categories,
            from.navigationController
        )
        coordinator.delegate = self
        
        from.start(child: coordinator)
    }
    
    func routeToProductDetailSummary(
        with data: ProductResponseElement,
        _ from: BaseCoordinator
    ) {
        let coordinator = ProductListCoordinator(
            from.navigationController
        )
        coordinator.delegate = self
        
        coordinator.routeToProductDetailSummary(with: data)
    }
    
    func routeToProductDetail(
        productID: Int,
        products: ProductListResponse,
        onScreenDismiss: (() -> Void)?,
        _ from: BaseCoordinator
    ) {
        let coordinator = ProductListCoordinator(
            from.navigationController
        )
        coordinator.delegate = self
        
        coordinator.routeToProductDetail(
            productID: productID,
            products: products,
            onScreenDismiss: onScreenDismiss
        )
    }
}
