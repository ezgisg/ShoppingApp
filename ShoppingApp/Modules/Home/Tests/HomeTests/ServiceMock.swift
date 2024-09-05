//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.09.2024.
//

import XCTest
import AppResources
import Network
@testable import Home

final class ServiceMock: ShoppingServiceProtocol {
    var network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
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

    
