
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
