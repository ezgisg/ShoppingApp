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
    var filteredProducts: ProductListResponse { get }
    var filteredCategories: [String] { get set }
    func fetchProducts(categoryName: String)
    func fetchCategories(categoryName: String)
}

// MARK: - ProductListViewModelDelegate
protocol ProductListViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

// MARK: - ProductListViewModelDelegate
final class ProductListViewModel {
    var filteredProducts: ProductListResponse = []
    var filteredCategories: [String] = []
    
    private var categories: [String] = []
    
    var delegate: ProductListViewModelDelegate?
    private var service: ShoppingServiceProtocol
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
    }
}


extension ProductListViewModel: ProductListViewModelProtocol {
    
    func fetchCategories(categoryName: String) {
        service.fetchCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                if categoryName == "" {
                    //TODO: Düzenlenecek localizable
                    self.filteredCategories = categories
                    self.filteredCategories.append("All")
                } else {
                    self.filteredCategories = categories.filter { $0.lowercased() == categoryName.lowercased() }
                }
                self.delegate?.reloadCollectionView()
            case .failure(_):
                debugPrint("Kategoriler yüklenemedi")
            }
        }
    }
    
    func fetchProducts(categoryName: String) {
        if categoryName != "" {
            service.fetchProductsFromCategory(categoryName: categoryName) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let products):
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
                    filteredProducts = products
                    delegate?.reloadCollectionView()
                case .failure(_):
                    debugPrint("Ürünler yüklenemedi")
                }
            }
        }
    }
    
}
