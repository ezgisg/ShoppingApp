
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

    func testFetchProducts_whenRequestSucceed_shouldGetProducts() {
        guard let mockResponse = ProductListMockDataProvider.allProductsSuccessData else { return }
        prepareMockedServicedSut(mockResponse: mockResponse, isSuccess: true, categories: [])
        sut.fetchProducts()
        XCTAssertNotNil(delegate.filterCount)
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
