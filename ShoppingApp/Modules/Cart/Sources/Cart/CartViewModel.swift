//
//  CartViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import AppResources
import Foundation
import Network

protocol CartViewModelProtocol: AnyObject {
    func getCartDatas()
    var cartItems: [Cart] { get }
    var products: [ProductResponseElement] { get }
}

protocol CartViewModelDelegate: AnyObject {
    func reloadData(cart: [ProductResponseElement])
}

public final class CartViewModel {
    weak var delegate: CartViewModelDelegate?
    public var cartItems: [Cart] = []
    public var products: [ProductResponseElement] = []
    private var service: ShoppingServiceProtocol
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
    }
}


extension CartViewModel: CartViewModelProtocol {
    public func getCartDatas() {
        cartItems = CartManager.shared.cartItems
        var fetchedProducts = [ProductResponseElement]()
        let dispatchGroup = DispatchGroup()
        
        let uniqueProductIds = Set(cartItems.map { $0.productId })
        
        for productId in uniqueProductIds {
            guard let productId else { return }
            dispatchGroup.enter()
            service.fetchProduct(productId: productId) { result in
                switch result {
                case .success(let product):
                    fetchedProducts.append(product)
                case .failure(let error):
                    print("Error fetching product: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {  [weak self] in
            guard let self else { return }
            var updatedProducts = [ProductResponseElement]()
            for item in cartItems {
                if var product = fetchedProducts.first(where: { $0.id == item.productId }) {
                    product.quantity = item.quantity
                    product.size = item.size
                    updatedProducts.append(product)
                }
            }
            
            products = updatedProducts
            self.delegate?.reloadData(cart: updatedProducts)
        }
    }
}
