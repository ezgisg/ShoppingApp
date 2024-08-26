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

//MARK: - CartViewModelProtocol
protocol CartViewModelProtocol: AnyObject {
    var cartItems: [Cart] { get }
    var products: [ProductResponseElement] { get }
    var similarProducts: [ProductResponseElement] { get }
    ///selection keeps separately from products because when something add-remove from cart, products array will renew completely
    var selectionOfProducts: [ProductResponseElement] { get }
    var selectedItemCount: Int { get }
    var isSelectAllActive: Bool { get }
    var couponStatus: CouponStatus { get }

    var totalPrice: Double? { get }
    var discountRate: Double? { get }
    var discount: Double? { get }
    var subTotal: Double? { get }
    var cargoFee: Double? { get }
    var priceToPay: Double? { get }
    
    func getCartDatas()
    func controlCoupon()
    func isSelectedProduct(id: Int, size: String) -> Bool?

}

//MARK: - CartViewModelDelegate
protocol CartViewModelDelegate: AnyObject {
    func reloadData()
    func showLoadingView()
    func hideLoading()
    func setTotalPrice()
    func deleteDiscountCoupon()
    func manageSumStackType(isThereDiscount: Bool)
}

//MARK: - CartViewModel
public final class CartViewModel {
    private var service: ShoppingServiceProtocol
    weak var delegate: CartViewModelDelegate?
    
    var cartItems: [Cart] = []
    var products: [ProductResponseElement] = [] {
        ///To remove discount coupon when there is no product
        didSet {
            if products.isEmpty {
                discountRate = nil
                delegate?.deleteDiscountCoupon()
            }
        }
    }
    var similarProducts: [ProductResponseElement] = []
    var selectionOfProducts: [ProductResponseElement] = []
    var totalPrice: Double? = 0
    var discountRate: Double? =  nil {
        didSet {
            calculatePrices()
            delegate?.setTotalPrice()
        }
    }
    var discount: Double? = 0 {
        didSet {
            if let discount,
               discount > 0 {
                delegate?.manageSumStackType(isThereDiscount: true)
            } else {
                delegate?.manageSumStackType(isThereDiscount: false)
            }
        }
    }
    var subTotal: Double? = 0
    var cargoFee: Double? = 0
    var priceToPay: Double? = 0
    
    var selectedItemCount: Int {
        return CartManager.shared.selectionOfProducts.filter { $0.isSelected == true }.count
    }
    var isSelectAllActive: Bool {
        return selectedItemCount == CartManager.shared.selectionOfProducts.count
    }
    
    var couponStatus = CouponStatus(text: "", isApplied: false, isValid: false)
    
    //MARK: - Init
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(selectionUpdated), name: .selectionUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
}

//MARK: - CartViewModelProtocol
extension CartViewModel: CartViewModelProtocol {
    ///In this scenario, actually adding/removing new products is sufficient, but normally when the data is received from the backend, it may be necessary to request the cart again for stock or other changes.
     func getCartDatas() {
        cartItems = CartManager.shared.cartItems
        var fetchedProducts = [ProductResponseElement]()
        var similarFetchedProducts = [ProductResponseElement]()
         
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
                        similarFetchedProducts.append(product)
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
            similarProducts = similarFetchedProducts
            calculatePrices()
            delegate?.reloadData()
            delegate?.hideLoading()
        }
    }
    
    func controlCoupon() {
        let discountRates: [String: Double] = [
             "DSC20": 20.0,
             "DSC10": 10.0
         ]
         let discountRate = discountRates[couponStatus.text]
         let isCouponValid = discountRate.map { $0 > 0 } ?? false
         
         couponStatus = CouponStatus(
             text: couponStatus.text,
             isApplied: couponStatus.isApplied,
             isValid: isCouponValid
         )
    }
    
    func isSelectedProduct(id: Int, size: String) -> Bool? {
        let isSelected = selectionOfProducts
            .first(where: { $0.id == id && $0.size == size })?
            .isSelected
        return isSelected
    }
}

//MARK: Actions
private extension CartViewModel {
    //TODO: selection ve cart update bitişince ortaklaşa haber alıp hideloading i ortaklaşa yapmak
    @objc final func selectionUpdated() {
        let selections = CartManager.shared.selectionOfProducts
        selectionOfProducts = selections
        calculatePrices()
        delegate?.reloadData()
    }
    
    @objc final func cartUpdated() {
        delegate?.showLoadingView()
        getCartDatas()
    }
}

//MARK: - Helpers
private extension CartViewModel {
    final func calculatePrices() {
        totalPrice = calculateTotalPrice()
        discount = (totalPrice ?? 0) * ((discountRate ?? 0) / 100)
        cargoFee = (totalPrice ?? 0) - (discount ?? 0) >= 300 ? 0.0 : 19.99
        subTotal = (totalPrice ?? 0) - (discount ?? 0)
        priceToPay = (subTotal ?? 0) + (cargoFee ?? 0)
        delegate?.setTotalPrice()
    }
    
    final func calculateTotalPrice() -> Double {
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

