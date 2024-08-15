//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import AppResources
import Foundation

///There is no logic for keeping cart items when app killed. To keep without backend,  userDefaults/CoreData can be used 
public class CartManager {
    public static let shared = CartManager()
    private init() {}

    private(set) var cartItems: [Cart] = []
    private(set) var selectionOfProducts: [ProductResponseElement] = []

    public func addToCart(productId: Int, size: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) {
            let currentQuantity = cartItems[index].quantity ?? 0
            cartItems[index].quantity = currentQuantity + 1
        } else {
            let newCartItem = Cart(productId: productId, size: size, quantity: 1)
            cartItems.append(newCartItem)
            let newProduct = ProductResponseElement(id: productId, size: size, isSelected: true)
            selectionOfProducts.append(newProduct)
            notifySelectionUpdate()
        }
        notifyCartUpdate()
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
        notifyCartUpdate()
    }
    
    private func removeFromSelection(productId: Int, size: String) {
        guard let index = selectionOfProducts.firstIndex(where: { $0.id == productId && $0.size == size }) else {
            return
        }
        selectionOfProducts.remove(at: index)
        notifySelectionUpdate()
    }

    public var totalItemsInCart: Int {
        return cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
    }
    
    public func updateProductSelection(productId: Int, size: String) {
        guard let index = selectionOfProducts.firstIndex(where: { $0.id == productId && $0.size == size }) else { return  }
        var product = selectionOfProducts[index]
        product.isSelected = !(product.isSelected ?? true)
        selectionOfProducts[index] = product
        notifySelectionUpdate()
    }
    
    public func isProductSelected(productId: Int, size: String) -> Bool {
        return selectionOfProducts.contains(where: { $0.id == productId && $0.size == size && ($0.isSelected ?? false) })
    }
    
    public func printCart() {
         for item in cartItems {
             print("Product ID: \(item.productId ?? 0), Size: \(item.size ?? "Unknown"), Quantity: \(item.quantity ?? 0)")
         }
     }
    
    private func notifyCartUpdate() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    private func notifySelectionUpdate() {
        NotificationCenter.default.post(name: .selectionUpdated, object: nil)
    }
}

public extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
    static let selectionUpdated = Notification.Name("selectionUpdated")
}
