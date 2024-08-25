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
        
        from.start(child: coordinator)
    }
}
