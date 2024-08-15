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
    var selectionOfProducts: [ProductResponseElement] { get }
}

protocol CartViewModelDelegate: AnyObject {
    func reloadData()
}

public final class CartViewModel {
    weak var delegate: CartViewModelDelegate?
    public var cartItems: [Cart] = []
    public var products: [ProductResponseElement] = []
    var selectionOfProducts: [ProductResponseElement] = []
    private var service: ShoppingServiceProtocol
    
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(selectionUpdated), name: .selectionUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
}

extension CartViewModel: CartViewModelProtocol {
    ///In this scenario, actually adding/removing new products is sufficient, but normally when the data is received from the backend, it may be necessary to request the cart again for stock or other changes.
    public func getCartDatas() {
        cartItems = CartManager.shared.cartItems
        let selectionOfProducts = CartManager.shared.selectionOfProducts
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
            self.delegate?.reloadData()
        }
    }
}

extension CartViewModel {
    @objc private func selectionUpdated() {
        let selections = CartManager.shared.selectionOfProducts
        selectionOfProducts = selections
        delegate?.reloadData()
    }
    
    @objc private func cartUpdated() {
        getCartDatas()
    }
}
