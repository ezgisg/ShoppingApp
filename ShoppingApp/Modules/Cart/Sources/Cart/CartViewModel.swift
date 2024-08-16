//
//  CartViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import AppResources
import AppManagers
import Foundation
import Network

protocol CartViewModelProtocol: AnyObject {
    func getCartDatas()
    var cartItems: [Cart] { get }
    var products: [ProductResponseElement] { get }
    var similarProducts: [ProductResponseElement] { get }
    ///selection keeps separately from products because when something add-remove from cart, products array will renew completely
    var selectionOfProducts: [ProductResponseElement] { get }
    var totalPrice: Double? { get }
}

protocol CartViewModelDelegate: AnyObject {
    func reloadData()
    func hideLoading()
    func setTotalPrice()
}

public final class CartViewModel {
    private var service: ShoppingServiceProtocol
    weak var delegate: CartViewModelDelegate?
    
    var cartItems: [Cart] = []
    var products: [ProductResponseElement] = []
    var similarProducts: [ProductResponseElement] = []
    var selectionOfProducts: [ProductResponseElement] = []
    var totalPrice: Double? = 0 {
        didSet {
            delegate?.setTotalPrice()
        }
    }
    
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
        var fetchedProducts = [ProductResponseElement]()
        var similarFethedProducts = [ProductResponseElement]()
        let dispatchGroup = DispatchGroup()
        
        let uniqueProductIds = Set(cartItems.map { $0.productId })
        let filteredUniqueProductIds = Set(uniqueProductIds.compactMap { $0 })
        let randomIds = generateRandomUniqueIds(excluding: filteredUniqueProductIds, count: 5)
        
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
        
        //To remove similar products when there is no product in cart
        if uniqueProductIds.count > 0 {
            for productId in randomIds {
                dispatchGroup.enter()
                service.fetchProduct(productId: productId) { result in
                    switch result {
                    case .success(let product):
                        similarFethedProducts.append(product)
                    case .failure(let error):
                        print("Error fetching similar product: \(error)")
                    }
                    dispatchGroup.leave()
                }
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
            similarProducts = similarFethedProducts
            totalPrice = calculateTotalPrice(from: products)
            self.delegate?.reloadData()
            delegate?.hideLoading()
        }
    }
}

//MARK: Actions
private extension CartViewModel {
    @objc final func selectionUpdated() {
        let selections = CartManager.shared.selectionOfProducts
        selectionOfProducts = selections
        totalPrice = calculateTotalPrice(from: products)
        delegate?.reloadData()
        delegate?.hideLoading()
    }
    
    @objc final func cartUpdated() {
        getCartDatas()
    }
}

//MARK: - Helpers
private extension CartViewModel {
    final func calculateTotalPrice(from products: [ProductResponseElement]) -> Double {
        return products.reduce(0.0) { total, product in
            let isSelected = selectionOfProducts.contains { selectedProduct in
                selectedProduct.id == product.id && selectedProduct.size == product.size && (selectedProduct.isSelected ?? false)
            }
            if isSelected {
                let productTotal = (product.price ?? 0.0) * Double(product.quantity ?? 0)
                return total + productTotal
            }
            return total
        }
    }
    
    final func generateRandomUniqueIds(excluding excludedIds: Set<Int>, count: Int) -> [Int] {
        let availableIds = Set(1...20).subtracting(excludedIds)
        let randomIds: [Int]
        if availableIds.count <= 5 {
            randomIds = Array(availableIds)
        } else {
            randomIds = Array(availableIds.shuffled().prefix(5))
        }
        return randomIds
    }
}
