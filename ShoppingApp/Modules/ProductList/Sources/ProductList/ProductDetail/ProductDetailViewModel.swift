//
//  ProductDetailViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 21.08.2024.
//

import AppResources
import Foundation
import Network

protocol ProductDetailViewModelProtocol: AnyObject {
    var product: ProductResponseElement? { get }
    func fetchProduct(productId: Int)
}

protocol ProductDetailViewModelDelegate: AnyObject {
    func reloadData()
}

final class ProductDetailViewModel {
    // MARK: - Private variables
    private var service: ShoppingService = ShoppingService()
    
    // MARK: - Variables
    public weak var delegate: ProductDetailViewModelDelegate?
    
    var product: ProductResponseElement? = nil
}


extension ProductDetailViewModel : ProductDetailViewModelProtocol {
    func fetchProduct(productId: Int) {
        service.fetchProduct(productId: productId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let productResponse):
                product = productResponse
                delegate?.reloadData()
            case .failure(let error):
                debugPrint("Ürün bilgileri yüklenemedi")
            }
        }
    }
    
    
}
