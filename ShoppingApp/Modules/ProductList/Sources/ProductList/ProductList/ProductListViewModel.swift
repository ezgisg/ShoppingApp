//
//  ProductListViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

//TODO: filter sonucunda ürün yoksa empty view koyulacak
//TODO: kaç ürün var filtrede göster
import AppResources
import Foundation
import Network

// MARK: - ProductListViewModelProtocol
public protocol ProductListViewModelProtocol: AnyObject {
    var delegate: ProductListViewModelDelegate? { get set }
    var filterDelegate: FilterDelegate? { get set }
    
    ///Common variables
    var categories: [CategoryResponseElement] { get }
    var filteredProducts: ProductListResponse { get set }
    var filterCount: Int { get }
    var selectedSortingOption: SortingOption { get set }
    var selectedCategories: Set<CategoryResponseElement> { get set }
    var selectedRatings: Set<RatingOption> { get set }
    var selectedPrices: Set<PriceOption> { get set }
    
    ///Variables for filterVC
    var filterInitialSelectedCategories: Set<CategoryResponseElement> { get set }
    var filterInitialSelectedRatings: Set<RatingOption> { get set }
    var filterInitialSelectedPrices: Set<PriceOption> { get set }
    var isDifferentFromInitialsOnFilter: Bool { get }
    
    ///Variables for filterDetailVC
    var filterDetailInitialSelectedCategories: Set<CategoryResponseElement> { get set }
    var filterDetailInitialSelectedRatings: Set<RatingOption> { get set }
    var filterDetailInitialSelectedPrices: Set<PriceOption> { get set }
    var isDifferentFromInitialsOnFilterDetail: Bool { get }
    var filteredRatings: [RatingOption] { get set }
    var filteredPrices: [PriceOption] { get set }
    var filteredCategories: [CategoryResponseElement] { get set }
    
    ///Functions for productList
    func fetchProducts()
    func filterProductsWithSelections()
    func sortProducts()
    
    ///Functions for filterVC
    func clearAllFilters()
    
    ///Functions for filterDetailVC
    func clearOrSelectAllFilters(filterOptionType: FilterOption)
    func getIndexOfSelection(for filterOption: FilterOption) -> [IndexPath]
    func searchWithTextInSelections(text: String, filterOption: FilterOption)
    func setOptions()
    
    ///Common Functions for filter screens
    func keepInitials(isDetailScreen: Bool)
    func returnToInitials(isDetailScreen: Bool)
}

// MARK: - ProductListViewModelDelegate
public protocol ProductListViewModelDelegate: AnyObject {
    func manageFilterStatus(filterCount: Int)
    func manageSortingStatus(isSortingActive: Bool)
}

// MARK: - FilterDelegate
public protocol FilterDelegate: AnyObject {
    func controlAllButtonStatus()
    func reloadTableView()
    func setupSelections()
}

public extension FilterDelegate {
    func setupSelections() { }
}

// MARK: - ProductListViewModelProtocol
public final class ProductListViewModel: ProductListViewModelProtocol {
    
    // MARK: - Private variables
    private var service: ShoppingService = ShoppingService()
    private var products: ProductListResponse = []
    
    // MARK: - Variables
    public weak var delegate: ProductListViewModelDelegate?
    public weak var filterDelegate: FilterDelegate?
    
    ///To keep available categories which is get from home/categories page
    public var categories: [CategoryResponseElement] = []
    public var filteredProducts: ProductListResponse = []
    public var filterCount: Int {
        return selectedPrices.count + selectedRatings.count + selectedCategories.count
    }
    ///For keep selected sorting option and trigger to sort func
    public var selectedSortingOption: SortingOption = .none {
        didSet {
            sortProducts()
        }
    }
    public var selectedCategories =  Set<CategoryResponseElement>() {
        didSet {
            ///Added main.async otherwise collection view animation dont work
            ///filterProductsWithSelections() added here in addition to 'product list will appear'. Because category filter is also on productListPage.
            DispatchQueue.main.async {  [weak self] in
                guard let self else { return }
                filterProductsWithSelections()
            }
        }
    }
    public var selectedRatings: Set<RatingOption> = []
    public var selectedPrices: Set<PriceOption> = []
    
    ///To keep the initial values ​​of  filterViewControl. It is required for control at the exit from the filtering screen.
    public var filterInitialSelectedCategories: Set<CategoryResponseElement> = []
    public var filterInitialSelectedRatings: Set<RatingOption> = []
    public var filterInitialSelectedPrices: Set<PriceOption> = []
    
    ///To keep the initial values ​​of  filterDetailViewControl. It is required for control at the exit from the filtering screen.
    public var filterDetailInitialSelectedCategories: Set<CategoryResponseElement> = []
    public var filterDetailInitialSelectedRatings: Set<RatingOption> = []
    public var filterDetailInitialSelectedPrices: Set<PriceOption> = []
    public var filteredRatings: [RatingOption] = []
    public var filteredPrices: [PriceOption] = []
    public var filteredCategories: [CategoryResponseElement] = []
    
    // MARK: - Init
    public init(categories: [CategoryResponseElement]) {
        self.categories = categories
    }
}

// MARK: - ProductListViewModel
public extension ProductListViewModel {
    var isDifferentFromInitialsOnFilter: Bool {
        return filterInitialSelectedPrices != selectedPrices ||
        filterInitialSelectedRatings != selectedRatings ||
        filterInitialSelectedCategories != selectedCategories
    }
    
    var isDifferentFromInitialsOnFilterDetail: Bool {
        return filterDetailInitialSelectedPrices != selectedPrices ||
        filterDetailInitialSelectedRatings != selectedRatings ||
        filterDetailInitialSelectedCategories != selectedCategories
    }
    
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
        guard 
            filterCount != 0
        else {
            filteredProducts = products
            delegate?.manageFilterStatus(filterCount: filterCount)
            return
        }
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
    
    func clearAllFilters() {
        guard filterCount > 0 else {
            filterDelegate?.controlAllButtonStatus()
            return
        }
        clearSelections()
        filterDelegate?.controlAllButtonStatus()
    }
    
    func clearOrSelectAllFilters(filterOptionType: FilterOption) {
        let count: Int = switch filterOptionType {
        case .category:
            selectedCategories.count
        case .price:
            selectedPrices.count
        case .rating:
            selectedRatings.count
        }
        
        if count > 0 {
            clearSelections(for: filterOptionType)
            filterDelegate?.controlAllButtonStatus()
            filterDelegate?.reloadTableView()
        } else {
            selectAllFilters(for: filterOptionType)
            filterDelegate?.controlAllButtonStatus()
        }
    }
    
    func getIndexOfSelection(for filterOption: FilterOption) -> [IndexPath] {
        func appendIndexes<T>(from items: [T], in allCases: [T]) -> [IndexPath] where T: Equatable {
            var indexes: [IndexPath] = []
            
            for item in items {
                if let index = allCases.firstIndex(of: item) {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexes.append(indexPath)
                }
            }
            return indexes
        }
        
        switch filterOption {
        case .rating:
            return appendIndexes(from: Array(selectedRatings), in: filteredRatings)
        case .price:
            return appendIndexes(from: Array(selectedPrices), in: filteredPrices)
        case .category:
            return appendIndexes(from: Array(selectedCategories), in: filteredCategories)
        }
    }
    
    func searchWithTextInSelections(text: String, filterOption: FilterOption) {
        guard text != ""
        else {
            setOptions()
            filterDelegate?.setupSelections()
            filterDelegate?.reloadTableView()
            return
        }
        switch filterOption {
        case .rating:
            filteredRatings = RatingOption.allCases.filter { $0.stringValue.lowercased().contains(text.lowercased()) }
        case .price:
            filteredPrices = PriceOption.allCases.filter { $0.stringValue.lowercased().contains(text.lowercased()) }
        case .category:
            filteredCategories = categories.filter {
                return $0.value?.lowercased().contains(text.lowercased()) == true }
        }
        filterDelegate?.setupSelections()
        filterDelegate?.reloadTableView()
    }
    
    func setOptions() {
        filteredPrices = PriceOption.allCases
        filteredRatings = RatingOption.allCases
        filteredCategories = categories
    }
    
    func keepInitials(isDetailScreen: Bool) {
        if isDetailScreen {
            filterDetailInitialSelectedPrices = selectedPrices
            filterDetailInitialSelectedRatings = selectedRatings
            filterDetailInitialSelectedCategories = selectedCategories
        } else {
            filterInitialSelectedPrices = selectedPrices
            filterInitialSelectedRatings = selectedRatings
            filterInitialSelectedCategories = selectedCategories
        }
    }
    
    func returnToInitials(isDetailScreen: Bool) {
        if isDetailScreen {
            selectedPrices = filterDetailInitialSelectedPrices
            selectedRatings = filterDetailInitialSelectedRatings
            selectedCategories = filterDetailInitialSelectedCategories
        } else {
            selectedPrices = filterInitialSelectedPrices
            selectedRatings = filterInitialSelectedRatings
            selectedCategories = filterInitialSelectedCategories
        }
    }
}

//MARK: - Helpers
private extension ProductListViewModelProtocol {
    func clearSelections(for filterOptionType: FilterOption? = nil) {
        if let filterOptionType {
            switch filterOptionType {
            case .rating:
                selectedRatings = []
            case .price:
                selectedPrices = []
            case .category:
                selectedCategories = []
            }
        } else {
            selectedPrices = []
            selectedRatings = []
            selectedCategories = []
        }
    }
    
    func selectAllFilters(for filterOptionType: FilterOption) {
        switch filterOptionType {
        case .rating:
            selectedRatings = Set(RatingOption.allCases)
        case .price:
            selectedPrices = Set(PriceOption.allCases)
        case .category:
            selectedCategories = Set(categories)
        }
    }
}
