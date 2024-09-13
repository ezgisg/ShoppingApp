
import XCTest
import AppResources
import Network
@testable import ProductList

final class ProductListViewModelTests: XCTestCase {
    private var sut: ProductListViewModel!
    private var delegate: ProductListViewModelDelegateMock!
    private var filterDelegate: ProductListViewModelFilterDelegateMock!
    
    override func setUp() {
        super.setUp()
        sut = ProductListViewModel(categories: [])
        delegate = ProductListViewModelDelegateMock()
        filterDelegate = ProductListViewModelFilterDelegateMock()
    }
    
    override func tearDown() {
        delegate = nil
        sut = nil
        filterDelegate = nil
        super.tearDown()
    }

    func testFetchProductsWithAllCategories_whenRequestSucceed_shouldGetProducts() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        XCTAssertNotNil(delegate.filterCount)
        XCTAssertEqual(sut.filteredProducts, mockResponse)
    }
    
    func testFetchProductsWithAllCategories_whenRequestFailure_shouldGetEmptyArray() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: false, categories: [])
        sut.fetchProducts()
        XCTAssertEqual(sut.filteredProducts, [])
    }
    
    func testFetchProductsWithOneCategory_whenRequestSucceed_shouldGetProducts() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [CategoryResponseElement(value: "electronics", imagePath: "")])
        sut.fetchProducts()
        XCTAssertNotNil(delegate.filterCount)
        XCTAssertEqual(sut.filteredProducts, mockResponse)
    }
    
    func testFetchProductsWithOneCategory_whenRequestFailure_shouldGetEmptyArray() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: false, categories: [CategoryResponseElement(value: "electronics", imagePath: "")])
        sut.fetchProducts()
        XCTAssertEqual(sut.filteredProducts, [])
    }
    
    func testFilterProducts_whenFilterCountZero_shouldGetFilteredProducts() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        sut.selectedPrices = []
        sut.selectedRatings = []
        sut.selectedCategories = []
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        sut.filterProductsWithSelections()
        XCTAssertEqual(sut.filteredProducts, sut.products)
    }
    
    func testFilterProducts_whenFilterCountGreaterThanZero_shouldGetFilteredProducts() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        sut.selectedPrices = [PriceOption.oneToTen, PriceOption.tenToHundred, PriceOption.hundredPlus]
        sut.selectedRatings = [RatingOption.onePlus, RatingOption.twoPlus, RatingOption.threePlus, RatingOption.fourPlus, RatingOption.zeroPlus]
        sut.selectedCategories = [CategoryResponseElement(value: "men's clothing", imagePath: "")]
        sut.filterProductsWithSelections()
        XCTAssertEqual(sut.filteredProducts.count, 4)
    }
    
    func testSortProducts_whenHighestPriceSelected_shouldGetHighestFirst() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        sut.selectedSortingOption = .highestPrice
        sut.sortProducts()
        let ordered = mockResponse?.sorted { $0.price! > $1.price! }
        let firstProduct = ordered?.first
        XCTAssertEqual(sut.filteredProducts.first?.title, firstProduct?.title)
    }
    
    func testSortProducts_whenLowestPriceSelected_shouldGetHighestFirst() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        sut.selectedSortingOption = .lowestPrice
        sut.sortProducts()
        let ordered = mockResponse?.sorted { $0.price! < $1.price! }
        let firstProduct = ordered?.first
        XCTAssertEqual(sut.filteredProducts.first?.title, firstProduct?.title)
    }
    
    func testSortProducts_whenDefaultSelected_shouldGetHighestFirst() {
        let mockResponse = ProductListMockDataProvider.allProductsSuccessData
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        sut.selectedSortingOption = .none
        sut.sortProducts()
        XCTAssertEqual(sut.filteredProducts.first?.title, mockResponse?.first?.title)
    }
    
    func testClearFilters_whenFilterCountZero_shouldCallControlButtonStatus() {
        sut.filterDelegate = filterDelegate
        sut.clearAllFilters()
        XCTAssertTrue(filterDelegate.isControlledButtonStatus)
    }
    
    func testClearFilters_whenFilterCountGreaterThanZero_shouldCallControlButtonStatus() {
        sut.filterDelegate = filterDelegate
        sut.selectedPrices = [PriceOption.oneToTen, PriceOption.tenToHundred, PriceOption.hundredPlus]
        sut.clearAllFilters()
        XCTAssertTrue(filterDelegate.isControlledButtonStatus)
        XCTAssertEqual(sut.selectedPrices, [])
    }
    
    func testSelectAllFilters_whenNoSelectedFilterOnPrice_shouldChangeFilters() {
        sut.filterDelegate = filterDelegate
        sut.clearOrSelectAllFilters(filterOptionType: .price)
        XCTAssertTrue(sut.selectedPrices.count > 0)
    }
    
    func testSelectAllFilters_whenNoSelectedFilterOnRating_shouldChangeFilters() {
        sut.filterDelegate = filterDelegate
        sut.clearOrSelectAllFilters(filterOptionType: .rating)
        XCTAssertTrue(sut.selectedRatings.count > 0)
    }
    
    func testClearFilters_whenAnyFilterSelected_shouldClearFilters() {
        sut.filterDelegate = filterDelegate
        sut.selectedCategories = [CategoryResponseElement(value: "men's clothing", imagePath: "")]
        sut.clearOrSelectAllFilters(filterOptionType: .category)
        XCTAssertTrue(sut.selectedCategories.count == 0)
    }
    
    func testGetIndex_whenForPrice_shouldGetFilterCountEqualSelectedPrices() {
        sut.filteredPrices = [PriceOption.oneToTen, PriceOption.tenToHundred, PriceOption.hundredPlus]
        sut.selectedPrices = [PriceOption.oneToTen, PriceOption.tenToHundred, PriceOption.hundredPlus]
        let indexs = sut.getIndexOfSelection(for: .price)
        XCTAssertEqual(indexs.count,sut.selectedPrices.count)
    }
    
    func testGetIndex_whenForRating_shouldGetFilterCountEqualSelectedRating() {
        sut.filteredRatings = [.fourPlus,.onePlus]
        sut.selectedRatings = []
        let indexs = sut.getIndexOfSelection(for: .rating)
        XCTAssertEqual(indexs.count,sut.selectedRatings.count)
    }
    
    func testGetIndex_whenForCategory_shouldGetFilterCountEqualSelectedCategories() {
        sut.filteredCategories = [CategoryResponseElement(value: "electronics", imagePath: "")]
        sut.selectedCategories = []
        let indexs = sut.getIndexOfSelection(for: .category)
        XCTAssertEqual(indexs.count,sut.selectedCategories.count)
    }
    
    func testSearchWithText_whenFilterOptionRating_shouldReturnFilteredSelections() {
        sut.filterDelegate = filterDelegate
        sut.searchWithTextInSelections(text: RatingOption.onePlus.stringValue, filterOption: .rating)
        XCTAssertTrue(filterDelegate.isSetupSelections)
        XCTAssertTrue(filterDelegate.isReload)
        XCTAssertEqual([RatingOption.onePlus], sut.filteredRatings)
    }
    
    func testSearchWithText_whenFilterOptionRatingWithNoText_shouldReturnFilteredSelections() {
        sut.filterDelegate = filterDelegate
        sut.searchWithTextInSelections(text: "", filterOption: .rating)
        XCTAssertTrue(filterDelegate.isSetupSelections)
        XCTAssertTrue(filterDelegate.isReload)
        XCTAssertEqual(sut.filteredPrices, PriceOption.allCases)
    }
    
    func testSearchWithText_whenFilterOptionPrice_shouldReturnFilteredSelections() {
        sut.filterDelegate = filterDelegate
        sut.searchWithTextInSelections(text: PriceOption.oneToTen.stringValue, filterOption: .price)
        XCTAssertTrue(filterDelegate.isSetupSelections)
        XCTAssertTrue(filterDelegate.isReload)
        XCTAssertEqual([PriceOption.oneToTen], sut.filteredPrices)
    }
    
    func testSearchWithText_whenFilterOptionCategories_shouldReturnFilteredSelections() {
        sut.filterDelegate = filterDelegate
        sut.categories = [CategoryResponseElement(value: "electronics", imagePath: ""), CategoryResponseElement(value: "jewelery", imagePath: "")]
        sut.searchWithTextInSelections(text: "ele", filterOption: .category)
        XCTAssertTrue(filterDelegate.isSetupSelections)
        XCTAssertTrue(filterDelegate.isReload)
        XCTAssertTrue(sut.filteredCategories.count == 2)
    }
    
}

private extension ProductListViewModelTests {
    final func prepareMockedServicedSut<T: Decodable>(
        mockResponse: T,
        isSuccess: Bool,
        categories: [CategoryResponseElement]
    ) {
        let mockNetworkManager = MockNetworkManager(
            isSuccess: isSuccess,
            response: mockResponse
        )
        let mockService = ServiceMock(network: mockNetworkManager)
        sut = ProductListViewModel(categories: categories, service: mockService)
        sut.delegate = delegate
    }
}
