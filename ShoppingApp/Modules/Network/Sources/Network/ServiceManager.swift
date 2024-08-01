//
//  ServiceManager.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Foundation

// MARK: - ShoppingServiceProtocol
protocol ShoppingServiceProtocol {
    func fetchProducts(productId: Int?, completion: @escaping (ProductResult) -> ())
    func fetchCategories(completion: @escaping (Result<[String],BaseError>) -> ())
    func fetchCarts(cartId: Int?, startDate: String?, endDate: String?, completion: @escaping (CartResult) -> ())
    func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductResult) -> ())
}

final class ShoppingService: ShoppingServiceProtocol {
    func fetchProducts(productId: Int?, completion: @escaping (ProductResult) -> ()) {
        NetworkManager.shared.request(Router.products(productId: productId), decodeToType: [ProductResponse].self, completion: completion)
    }
    
    func fetchCategories(completion: @escaping (Result<[String], BaseError>) -> ()) {
        NetworkManager.shared.request(Router.categories, decodeToType: [String].self, completion: completion)
    }
    
    func fetchCarts(cartId: Int?, startDate: String?, endDate: String?, completion: @escaping (CartResult) -> ()) {
        NetworkManager.shared.request(Router.carts(cartId: cartId, startDate: startDate, endDate: endDate), decodeToType: [CartResponse].self, completion: completion)
    }
    
    func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductResult) -> ()) {
        NetworkManager.shared.request(Router.productsFromCategory(categoryName: categoryName), decodeToType: [ProductResponse].self, completion: completion)
    }
    
}
