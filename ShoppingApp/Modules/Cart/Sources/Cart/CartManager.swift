//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import Foundation

public class CartManager {
    public static let shared = CartManager()
    private init() {}

    private(set) var cartItems: [Cart] = []

    public func addToCart(productId: Int, size: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) {
            let currentQuantity = cartItems[index].quantity ?? 0
            cartItems[index].quantity = currentQuantity + 1
        } else {
            let newCartItem = Cart(productId: productId, size: size, quantity: 1)
            cartItems.append(newCartItem)
        }
        notifyCartUpdate()
    }

    public func removeFromCart(productId: Int, size: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId && $0.size == size }) {
            let currentQuantity = cartItems[index].quantity ?? 0
            if currentQuantity > 1 {
                cartItems[index].quantity = currentQuantity - 1
            } else {
                cartItems.remove(at: index)
            }
            notifyCartUpdate()
        }
    }

    public var totalItemsInCart: Int {
        return cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
    }

    public func printCart() {
         for item in cartItems {
             print("Product ID: \(item.productId ?? 0), Size: \(item.size ?? "Unknown"), Quantity: \(item.quantity ?? 0)")
         }
     }
    
    private func notifyCartUpdate() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
