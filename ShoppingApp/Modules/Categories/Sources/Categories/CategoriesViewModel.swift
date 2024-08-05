//
//  CategoriesViewModel.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import AppResources
import Foundation
import Network

// MARK: - CategoriesViewModelProtocol
protocol CategoriesViewModelProtocol: AnyObject {
    func fetchCategories()
}

// MARK: - CategoriesViewModelDelegate
protocol CategoriesViewModelDelegate: AnyObject {
    func getCategories(categories: [CategoryResponseElement])
}

// MARK: - CategoriesViewModel
final class CategoriesViewModel {
    var delegate: CategoriesViewModelDelegate?
    private var service: ShoppingServiceProtocol
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
    }
}

// MARK: - CategoriesViewModelProtocol
extension CategoriesViewModel: CategoriesViewModelProtocol {
    func fetchCategories() {
        service.fetchCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                let categoryElements = categories.map { CategoryResponseElement(value: $0) }
                self.delegate?.getCategories(categories: categoryElements)
            case .failure(_):
                debugPrint("Kategoriler yüklenemedi")
            }
        }
    }

}
