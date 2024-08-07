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
    func fetchProductsWithSelectedCategories(categories: Set<CategoryResponseElement>)
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
    
    func fetchProductsWithSelectedCategories(categories: Set<CategoryResponseElement>) {
        if categories.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                guard let productCategory = product.category else { return false }
                return categories.contains { $0.value == productCategory }
            }
        }
        delegate?.reloadCollectionView()

    }
}
