//
//  CartViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    func getCartDatas()
    var cartItems: [Cart] { get }
}

protocol CartViewModelDelegate: AnyObject {
    func reloadData(cart: [Cart])
}

public final class CartViewModel {
    weak var delegate: CartViewModelDelegate?
    public var cartItems: [Cart] = []
}


extension CartViewModel: CartViewModelProtocol {
    public func getCartDatas() {
        cartItems = CartManager.shared.cartItems
        delegate?.reloadData(cart: cartItems)
    }
}
