//
//  ProductListViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import Foundation
import Network

//TODO: Localizable for texts
///Unfortunately all filter options defined statically on screens because there is no backend to fetch data and to keep user selections
///Using enums to conveniently manage localizable
//MARK: - Enums
//MARK: - FilterOption
enum FilterOption: Int, CaseIterable {
    case rating = 0
    case price = 1
    case category = 2
    
    var stringValue: String {
        switch self {
        case .rating:
            return "Rating"
        case .price:
            return "Price"
        case .category:
            return "Category"
        }
    }
    
    //TODO: burası kullanılmadı, kullanılamazsa silinecek
    var options: Any {
        switch self {
        case .rating:
            return RatingOption.allCases
        case .price:
            return PriceOption.allCases
        case .category:
            return [CategoryResponseElement].self
        }
    }
}

//MARK: - RatingOption
public enum RatingOption: Double, CaseIterable {
    case zeroPlus = 0.0
    case onePlus = 1.0
    case twoPlus = 2.0
    case threePlus = 3.0
    case fourPlus = 4.0

    var stringValue: String {
        switch self {
        case .zeroPlus:
            return "0 - 1 Puan Arası"
        case .onePlus:
            return "1 - 2 Puan Arası"
        case .twoPlus:
            return "2 - 3 Puan Arası"
        case .threePlus:
            return "3 - 4 Puan Arası"
        case .fourPlus:
            return "4 - 5 Puan Arası"
        }
    }
}

enum ProductListScreenSectionType: Int, CaseIterable, Hashable {
    case filter = 0
    case products = 1
    
    var stringValue: String? {
         switch self {
         case .filter:
             return "Filter"
         case .products:
             return "Products"
         }
     }
}

//MARK: - Price Options
public enum PriceOption: Int, CaseIterable {
    case oneToTen = 1
    case tenToHundred = 10
    case hundredPlus = 100
    
    var stringValue: String {
        switch self {
        case .oneToTen:
            return "1 - 10 $"
        case .tenToHundred:
            return "10 - 100 $"
        case .hundredPlus:
            return "100+ $"
        }
    }
}

// MARK: - ProductListViewModelProtocol
public protocol ProductListViewModelProtocol: AnyObject {
    var delegate: ProductListViewModelDelegate? { get set }
    var filterDelegate: FilterDelegate? { get set }
    var categories: [CategoryResponseElement] { get }
    var filteredProducts: ProductListResponse { get set }
    var selectedSortingOption: SortingOption { get set }
    var selectedCategories: Set<CategoryResponseElement> { get set }
    var selectedRatings: Set<RatingOption> { get set }
    var selectedPrices: Set<PriceOption> { get set }
    
    var filterInitialSelectedCategories: Set<CategoryResponseElement> { get set }
    var filterInitialSelectedRatings: Set<RatingOption> { get set }
    var filterInitialSelectedPrices: Set<PriceOption> { get set }

    var isDifferentFromInitialsOnFilter: Bool { get }
    
    func fetchProducts()
    func sortProducts()
    func filterProductsWithSelections()
    
    func clearAllFilters()
    
}

// MARK: - ProductListViewModelDelegate
public protocol ProductListViewModelDelegate: AnyObject {
    func manageFilterStatus(filterCount: Int)
    func manageSortingStatus(isSortingActive: Bool)
}

// MARK: - FilterDelegate
public protocol FilterDelegate: AnyObject {
    func controlAllButtonStatus(filterCount: Int)
    func reloadTableView()
}



// MARK: - ProductListViewModelProtocol
public final class ProductListViewModel: ProductListViewModelProtocol {
   
    // MARK: - Private variables
    private var service: ShoppingService = ShoppingService()
    private var products: ProductListResponse = []
    private var filterCount: Int {
        return selectedPrices.count + selectedRatings.count + selectedCategories.count
    }
    
    // MARK: - Variables
    public var delegate: ProductListViewModelDelegate?
    public var filterDelegate: FilterDelegate?
    public var categories: [CategoryResponseElement] = []
    public var filteredProducts: ProductListResponse = []
    public var selectedSortingOption: SortingOption = .none {
        didSet {
            sortProducts()
        }
    }
    public var selectedCategories =  Set<CategoryResponseElement>() {
        didSet {
            ///Added main.async otherwise collection view animation dont work
            DispatchQueue.main.async {  [weak self] in
                guard let self else { return }
                filterProductsWithSelections()
            }
        }
    }
    public var selectedRatings: Set<RatingOption> = []
    public var selectedPrices: Set<PriceOption> = []
    
    
    public var filterInitialSelectedCategories: Set<CategoryResponseElement> = []
    public var filterInitialSelectedRatings: Set<RatingOption> = []
    public var filterInitialSelectedPrices: Set<PriceOption> = []

    
    // MARK: - Init
    public init(categories: [CategoryResponseElement]) {
        self.categories = categories
    }
    
}

// MARK: - ProductListViewModel
public extension ProductListViewModel {
    func fetchProducts() {
        if categories.count == 1, 
            let category = categories.first?.value {
            service.fetchProductsFromCategory(categoryName: category) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let products):
                    self.products = products
                    filteredProducts = products
                    delegate?.manageFilterStatus(filterCount: filterCount)
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
                    delegate?.manageFilterStatus(filterCount: filterCount)
                case .failure(_):
                    debugPrint("Ürünler yüklenemedi")
                }
            }
        }
    }
    
    func filterProductsWithSelections() {
        guard filterCount != 0
        else {
            delegate?.manageFilterStatus(filterCount: filterCount)
            return filteredProducts = products }
        filteredProducts = products.filter { product in
            var matchesCategory = true
            var matchesRating = true
            var matchesPrice = true
            
            if !selectedCategories.isEmpty {
                guard let productCategory = product.category else { return false }
                matchesCategory = selectedCategories.contains { $0.value == productCategory }
            }
            if !selectedRatings.isEmpty {
                guard let productRating = product.rating?.rate else { return false }
                matchesRating = selectedRatings.contains {
                    return $0.rawValue...($0.rawValue + 1.0) ~= productRating
                }
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
        delegate?.manageFilterStatus(filterCount: filterCount)
    }
    
    func sortProducts() {
        var isSortingActive = true
        switch selectedSortingOption {
        case .highestPrice:
            filteredProducts.sort { $0.price ?? 0 > $1.price ?? 0 }
        case .lowestPrice:
            filteredProducts.sort { $0.price ?? 0 < $1.price ?? 0}
        case .none:
            filteredProducts.sort { $0.id ?? 0 < $1.id ?? 0}
            isSortingActive = false
        }
        delegate?.manageSortingStatus(isSortingActive: isSortingActive)
    }
    
    var isDifferentFromInitialsOnFilter: Bool {
        return filterInitialSelectedPrices != selectedPrices ||
               filterInitialSelectedRatings != selectedRatings ||
               filterInitialSelectedCategories != selectedCategories
    }
    
    func clearAllFilters() {
        guard filterCount > 0 else {
            filterDelegate?.controlAllButtonStatus(filterCount: filterCount)
            return }
        selectedPrices = []
        selectedRatings = []
        selectedCategories = []
        filterDelegate?.reloadTableView()
        filterDelegate?.controlAllButtonStatus(filterCount: filterCount)
    }
    
}
