//
//  ServiceManager.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Foundation

// MARK: - ShoppingServiceProtocol
public protocol ShoppingServiceProtocol {
    func fetchProducts(completion: @escaping (ProductListResult) -> ())
    func fetchProduct(productId: Int, completion: @escaping (ProductResult) -> ())
    func fetchCategories(completion: @escaping (Result<[String],BaseError>) -> ())
    func fetchCarts(startDate: String?, endDate: String?, completion: @escaping (CartListResult) -> ())
    func fetchCart(cartId: Int, completion: @escaping (CartResult) -> ())
    func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductListResult) -> ())
}

public final class ShoppingService: ShoppingServiceProtocol {

    public init() { }
    
    public func fetchProducts(completion: @escaping (ProductListResult) -> ()) {
        NetworkManager.shared.request(Router.products, decodeToType: ProductListResponse.self, completion: completion)
    }
    
    public func fetchProduct(productId: Int, completion: @escaping (ProductResult) -> ()) {
        NetworkManager.shared.request(Router.product(productId: productId), decodeToType: ProductResponseElement.self, completion: completion)
    }
    
    public func fetchCategories(completion: @escaping (Result<[String], BaseError>) -> ()) {
        NetworkManager.shared.request(Router.categories, decodeToType: [String].self, completion: completion)
    }
    
    public func fetchCarts(startDate: String? = nil, endDate: String? = nil, completion: @escaping (CartListResult) -> ()) {
        NetworkManager.shared.request(Router.carts(startDate: startDate, endDate: endDate), decodeToType: CartListResponse.self, completion: completion)
    }
    
    public func fetchCart(cartId: Int, completion: @escaping (CartResult) -> ()) {
        NetworkManager.shared.request(Router.cart(cartId: cartId), decodeToType: CartResponseElement.self, completion: completion)
    }
    
    public func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductListResult) -> ()) {
        NetworkManager.shared.request(Router.productsFromCategory(categoryName: categoryName), decodeToType: ProductListResponse.self, completion: completion)
    }
    
}
