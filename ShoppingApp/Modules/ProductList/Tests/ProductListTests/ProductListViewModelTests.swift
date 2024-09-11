
import XCTest
import AppResources
import Network
@testable import ProductList

final class ProductListViewModelTests: XCTestCase {
    private var sut: ProductListViewModel!
    private var delegate: ProductListViewModelDelegateMock!
    
    override func setUp() {
        super.setUp()
        sut = ProductListViewModel(categories: [])
        delegate = ProductListViewModelDelegateMock()
    }
    
    override func tearDown() {
        delegate = nil
        sut = nil
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
