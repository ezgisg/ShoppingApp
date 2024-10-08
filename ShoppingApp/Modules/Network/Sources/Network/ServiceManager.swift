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
    var network: NetworkProtocol { get set }

    func fetchProducts(completion: @escaping (ProductListResult) -> ())
    func fetchProduct(productId: Int, completion: @escaping (ProductResult) -> ())
    func fetchCategories(completion: @escaping (Result<[String],BaseError>) -> ())
    func fetchCarts(startDate: String?, endDate: String?, completion: @escaping (CartListResult) -> ())
    func fetchCart(cartId: Int, completion: @escaping (CartResult) -> ())
    func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductListResult) -> ())
}

public final class ShoppingService: ShoppingServiceProtocol {
    
    public var network: NetworkProtocol = NetworkManager.shared

    public init() { }
    
    public func fetchProducts(completion: @escaping (ProductListResult) -> ()) {
        network.request(Router.products, decodeToType: ProductListResponse.self, completion: completion)
    }
    
    public func fetchProduct(productId: Int, completion: @escaping (ProductResult) -> ()) {
        network.request(Router.product(productId: productId), decodeToType: ProductResponseElement.self, completion: completion)
    }
    
    public func fetchCategories(completion: @escaping (Result<[String], BaseError>) -> ()) {
        network.request(Router.categories, decodeToType: [String].self, completion: completion)
    }
    
    public func fetchCarts(startDate: String? = nil, endDate: String? = nil, completion: @escaping (CartListResult) -> ()) {
        network.request(Router.carts(startDate: startDate, endDate: endDate), decodeToType: CartListResponse.self, completion: completion)
    }
    
    public func fetchCart(cartId: Int, completion: @escaping (CartResult) -> ()) {
        network.request(Router.cart(cartId: cartId), decodeToType: CartResponseElement.self, completion: completion)
    }
    
    public func fetchProductsFromCategory(categoryName: String, completion: @escaping (ProductListResult) -> ()) {
        network.request(Router.productsFromCategory(categoryName: categoryName), decodeToType: ProductListResponse.self, completion: completion)
    }
    
}
