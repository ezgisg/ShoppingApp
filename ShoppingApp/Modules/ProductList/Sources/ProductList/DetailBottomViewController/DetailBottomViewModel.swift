//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import Foundation
import Network


// MARK: - DetailBottomViewModelProtocol
protocol DetailBottomViewModelProtocol: AnyObject {
    var product: ProductResponseElement? { get }
    var productSizeData: ProductStockModel? { get set }
    var selectedSize: String? { get set }
    var isAddCartButtonEnabled: Bool? { get }

    func isEnabledisSelected(index: Int) -> (Bool, Bool)
    func loadStockData(for id: Int)
    func fetchProduct(productId: Int)
}

// MARK: - DetailBottomViewModelDelegate
protocol DetailBottomViewModelDelegate: AnyObject {
    func reloadData()
    func controlAddToCartButtonStatus(isEnabled: Bool)
    func hideLoading()
}

// MARK: - DetailBottomViewModelDelegate
extension DetailBottomViewModelDelegate {
    func hideLoading() {}
}

// MARK: - DetailBottomViewModel
public final class DetailBottomViewModel {
    
    weak var delegate: DetailBottomViewModelDelegate?
    
    // MARK: - Private variables
    private var service: ShoppingService = ShoppingService()
    ///For managing loading view status
    private var isStockDataLoaded = false
    private var isProductFetched = false

    // MARK: - Variables
    var product: ProductResponseElement? = nil
    var productSizeData: ProductStockModel? = nil
    var selectedSize: String? = nil {
        didSet {
            ///To control if there is a stock or not for one size product. If there is only one size and there is stock for this size, the size is selected automatically, otherwise is not
            var isThereStock = true
            if productSizeData?.sizes.count == 1,
               productSizeData?.sizes.first?.stock == 0 {
                isThereStock = false
            }
            let isEnabled = (selectedSize != nil && isThereStock)
            delegate?.controlAddToCartButtonStatus(isEnabled: isEnabled)
        }
    }
    var isAddCartButtonEnabled: Bool? {
        ///To choose size automatically if there is just one size and there is a stock for this size
        if let sizes = productSizeData?.sizes,
           sizes.count == 1,
           productSizeData?.sizes.first?.stock != 0
        {
            selectedSize = sizes[0].size
            return true
        } else {
            return false
        }
    }
}

// MARK: - DetailBottomViewModelProtocol
extension DetailBottomViewModel: DetailBottomViewModelProtocol {
    final func isEnabledisSelected(index: Int) -> (Bool,Bool) {
        guard let sizeData = productSizeData?.sizes[index] else { return (false,false) }
        let isInStock = sizeData.stock > 0
        let isSelected = isInStock && selectedSize == sizeData.size
        return (isInStock,isSelected)
    }
    
    //TODO: hata durumlarında uyarı vs..
    final func loadStockData(for id: Int) {
        guard let url = Bundle.module.url(forResource: "productSize", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let productsResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
            if let productData = productsResponse.products.first(where: { $0.id == id }) {
                productSizeData = productData
                delegate?.reloadData()
            } else {
                print("Error: Product with id \(id) not found.")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        isStockDataLoaded = true
        checkAndHideLoadingIfNeeded()
    }
    
    final func fetchProduct(productId: Int) {
        service.fetchProduct(productId: productId) { [weak self] result in
            guard let self else { return }
            isProductFetched = true
            checkAndHideLoadingIfNeeded()
            switch result {
            case .success(let productResponse):
                product = productResponse
                delegate?.reloadData()
            case .failure(let error):
                debugPrint("Ürün bilgileri yüklenemedi \(error)")
            }
        }
    }
}

//MARK: - Helpers
private extension DetailBottomViewModel {
    final func checkAndHideLoadingIfNeeded() {
        if isStockDataLoaded && isProductFetched {
            delegate?.hideLoading()
        }
    }
}

