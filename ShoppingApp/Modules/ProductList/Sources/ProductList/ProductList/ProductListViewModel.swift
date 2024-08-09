//
//  ProductListViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import Foundation
import Network

// MARK: - ProductListViewModelProtocol
protocol ProductListViewModelProtocol: AnyObject {
    var products: ProductListResponse { get }
    var filteredProducts: ProductListResponse { get }
    func fetchProducts(categoryName: String)
    func fetchProductsWithSelections(categories: Set<CategoryResponseElement>, selectedRatings: Set<RatingOption>, selectedPrices: Set<PriceOption>)
}

// MARK: - ProductListViewModelDelegate
protocol ProductListViewModelDelegate: AnyObject {
    func reloadCollectionView()

}

// MARK: - ProductListViewModelDelegate
final class ProductListViewModel {
    var products: ProductListResponse = []
    var filteredProducts: ProductListResponse = []
    
    var delegate: ProductListViewModelDelegate?
    private var service: ShoppingServiceProtocol
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
    }
}


extension ProductListViewModel: ProductListViewModelProtocol {

    func fetchProducts(categoryName: String) {
        if categoryName != "" {
            service.fetchProductsFromCategory(categoryName: categoryName) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let products):
                    self.products = products
                    filteredProducts = products
                    delegate?.reloadCollectionView()
                case .failure(_):
                    debugPrint("Ürünler yüklenemedi")
                }
            }
        } else {
            service.fetchProducts { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let products):
                    self.products = products
                    filteredProducts = products
                    delegate?.reloadCollectionView()
                case .failure(_):
                    debugPrint("Ürünler yüklenemedi")
                }
            }
        }
    }
    
    func fetchProductsWithSelections(categories: Set<CategoryResponseElement>, selectedRatings: Set<RatingOption>, selectedPrices: Set<PriceOption>) {
        if categories.isEmpty && selectedRatings.isEmpty && selectedPrices.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                var matchesCategory = true
                var matchesRating = true
                var matchesPrice = true
                
            
                if !categories.isEmpty {
                    guard let productCategory = product.category else { return false }
                    matchesCategory = categories.contains { $0.value == productCategory }
                }
                
         
                if !selectedRatings.isEmpty {
                    guard let productRating = product.rating?.rate else { return false }
                    matchesRating = selectedRatings.contains { $0.rawValue <= productRating }
                }
                
         
                if !selectedPrices.isEmpty {
                    guard let productPrice = product.price else { return false }
                    matchesPrice = selectedPrices.contains {
                        switch $0 {
                        case .oneToTen:
                            return 1...10 ~= productPrice
                        case .tenToHundred:
                            return 10...100 ~= productPrice
                        case .hundredPlus:
                            return productPrice >= 100
                        }
                    }
                }
                
                return matchesCategory && matchesRating && matchesPrice
            }
        }
        delegate?.reloadCollectionView()
    }
}
