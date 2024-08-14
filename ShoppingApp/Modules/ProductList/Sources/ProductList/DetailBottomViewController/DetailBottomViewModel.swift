//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import Foundation

// MARK: - DetailBottomViewModelProtocol
protocol DetailBottomViewModelProtocol: AnyObject {
    var productSizeData: ProductStockModel? { get set }
    var selectedSize: String? { get set }
    func loadStockData(for id: Int)
}

// MARK: - DetailBottomViewModelDelegate
protocol DetailBottomViewModelDelegate: AnyObject {
    func reloadData()
    func controlAddToCartButtonStatus(isEnabled: Bool)
}

// MARK: - DetailBottomViewModel
final class DetailBottomViewModel {
    weak var delegate: DetailBottomViewModelDelegate?
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
}

// MARK: - DetailBottomViewModelProtocol
extension DetailBottomViewModel: DetailBottomViewModelProtocol {
    //TODO: hata durumlarında uyarı vs..
    func loadStockData(for id: Int) {
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
      }
}
