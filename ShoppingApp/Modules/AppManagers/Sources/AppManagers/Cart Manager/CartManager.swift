//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import AppResources
import Combine
import Foundation

///There is no logic for keeping cart items when app killed. To keep without backend,  userDefaults/CoreData can be used
public class CartManager {
    public static let shared = CartManager()
    private init() {}
    
    public var cartItems: [Cart] = []
    public var selectionOfProducts: [ProductResponseElement] = []
    
    public var cartItemsPublisher = CurrentValueSubject<[Cart], Error>([])
    public var selectionOfProductsPublisher = CurrentValueSubject<[ProductResponseElement], Error>([])
    
    public func addToCart(productId: Int, size: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) {
            let currentQuantity = cartItems[index].quantity ?? 0
            cartItems[index].quantity = currentQuantity + 1
        } else {
            let newCartItem = Cart(productId: productId, size: size, quantity: 1)
            cartItems.append(newCartItem)
            let newProduct = ProductResponseElement(id: productId, size: size, isSelected: true)
            selectionOfProducts.append(newProduct)
        }
        cartItemsPublisher.send(cartItems)
    }

    public func removeFromCart(productId: Int, size: String) {
        guard let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) else { return }
        
        var item = cartItems[index]
        if let quantity = item.quantity, quantity > 1 {
            item.quantity = quantity - 1
            cartItems[index] = item
        } else {
            cartItems.remove(at: index)
            removeFromSelection(productId: productId, size: size)
        }
        cartItemsPublisher.send(cartItems)
    }
    
    public func removeAllSelectedFromCart() {
        let selectedProducts = selectionOfProducts.filter { $0.isSelected == true }
        for product in selectedProducts {
            guard let productId = product.id,
                  let size = product.size,
                  let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) else { return }
            cartItems.remove(at: index)
        }
        
        cartItemsPublisher.send(cartItems)
        DispatchQueue.main.async {  [weak self] in
            guard let self else { return }
            removeAllSelectedProducts()
        }
      
    }
    
    private func removeFromSelection(productId: Int, size: String) {
        guard let index = selectionOfProducts.firstIndex(where: { $0.id == productId && $0.size == size }) else {
            return
        }
        selectionOfProducts.remove(at: index)
        selectionOfProductsPublisher.send(selectionOfProducts)
    }
    
    public func removeAllSelectedProducts() {
        selectionOfProducts.removeAll { $0.isSelected == true }
        selectionOfProductsPublisher.send(selectionOfProducts)
    }

    public var totalItemsInCart: Int {
        return cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
    }
    
    public func updateProductSelection(productId: Int, size: String) {
        guard let index = selectionOfProducts.firstIndex(where: { $0.id == productId && $0.size == size }) else { return  }
        var product = selectionOfProducts[index]
        product.isSelected = !(product.isSelected ?? true)
        selectionOfProducts[index] = product
        selectionOfProductsPublisher.send(selectionOfProducts)
    }
    
    public func updateAllProductsSelection(to isSelected: Bool) {
        for index in selectionOfProducts.indices {
            var product = selectionOfProducts[index]
            product.isSelected = isSelected
            selectionOfProducts[index] = product
        }
        selectionOfProductsPublisher.send(selectionOfProducts)
    }
    
    public func isProductSelected(productId: Int, size: String) -> Bool {
        return selectionOfProducts.contains(where: { $0.id == productId && $0.size == size && ($0.isSelected ?? false) })
    }
}
