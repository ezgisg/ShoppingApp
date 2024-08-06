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
    var banners : [BannerElement] { get }
    var filteredCategories: [CategoryResponseElement]  { get set }
    func fetchCategories()
    func searchInCategories(searchText: String)
}

// MARK: - CategoriesViewModelDelegate
protocol CategoriesViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

// MARK: - CategoriesViewModel
final class CategoriesViewModel {
    var delegate: CategoriesViewModelDelegate?
    private var service: ShoppingServiceProtocol
    
    var filteredCategories: [CategoryResponseElement] = []
    private var categories : [CategoryResponseElement] = []
    
    //for mocking data
    var banners: [BannerElement] = [BannerElement(imagePath: "https://img.freepik.com/free-vector/flat-design-e-commerce-website-landing-page_23-2149581952.jpg?t=st=1722854157~exp=1722857757~hmac=885e196d1daa6b95704a327715ecc42310a1168aec293a4de39eb0de2a75ff53&w=1800")]
    private var imagePath =         [
        "https://img.freepik.com/free-photo/smartwatch-screen-digital-device_53876-96809.jpg?w=996&t=st=1722862900~exp=1722863500~hmac=8695f1ec074900415fcac5d07c780e8d67d6cb8366934095f85b734c861d8c66",
        "https://img.freepik.com/free-photo/view-luxurious-golden-ring_23-2150329701.jpg?t=st=1722862114~exp=1722865714~hmac=144b5c8bff17ec99c7fd8e7593b4395aeb8c1183b0129fb34636e132f7eb95d9&w=740",
        "https://img.freepik.com/free-photo/portrait-fashionable-boy-outdoors_23-2148184869.jpg?t=st=1722862823~exp=1722866423~hmac=78c3fe4b8ec7fdba436f13637154cd634f9f5f5d1f0abd44f8d4989ad5147885&w=996",
        "https://img.freepik.com/free-photo/portrait-young-japanese-woman-with-jacket_23-2148870730.jpg?t=st=1722862778~exp=1722866378~hmac=66d3aa11e393214d4263b8bf50c6e76bdaf6166e116376f7de5af988932ede07&w=996"
    ]
    
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
                let categoryElements = zip(categories, self.imagePath).map { CategoryResponseElement(value: $0.0, imagePath: $0.1) }
                self.categories = categoryElements
                filteredCategories = categoryElements
                self.delegate?.reloadCollectionView()
            case .failure(_):
                debugPrint("Kategoriler yüklenemedi")
            }
        }
    }
    
    func searchInCategories(searchText: String) {
        guard !searchText.isEmpty
        else
        {
            filteredCategories = categories
            self.delegate?.reloadCollectionView()
            return
        }
        filteredCategories = categories.filter { category in
            return category.value?.lowercased().contains(searchText.lowercased()) ?? false
        }
        self.delegate?.reloadCollectionView()
    }

}
