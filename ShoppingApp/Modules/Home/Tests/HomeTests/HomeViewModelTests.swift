

import XCTest
import Network
@testable import Home

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var delegate: HomeViewModelDelegateMock!
    
    override func setUp() {
        super.setUp()
        delegate = HomeViewModelDelegateMock()
        sut = HomeViewModel()
    }
    
    override func tearDown() {
        delegate = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchCategories_whenRequestSucceed_shouldGetCategories() {
        let mockResponse = ["Ezgi", "Sümer", "Günaydın"]
        prepareMockedServicedSut(
            mockResponse: mockResponse,
            isSuccess: true
        )
        
        sut.fetchCategories()
        
        XCTAssertEqual(delegate.calledCategories, mockResponse)
    }
}

private extension HomeViewModelTests {
    final func prepareMockedServicedSut<T: Decodable>(
        mockResponse: T,
        isSuccess: Bool
    ) {
        let mockNetworkManager = MockNetworkManager(
            isSuccess: isSuccess,
            response: mockResponse
        )
        let mockService = ServiceMock(network: mockNetworkManager)
        sut = HomeViewModel(service: mockService)
        sut.delegate = delegate
    }
}
