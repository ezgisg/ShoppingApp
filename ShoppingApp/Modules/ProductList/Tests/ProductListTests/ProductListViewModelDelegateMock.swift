


import Foundation
@testable import ProductList

final class ProductListViewModelDelegateMock: ProductListViewModelDelegate {
    
    var filterCount: Int?
    
    func manageFilterStatus(filterCount: Int) {
        self.filterCount = filterCount
    }
    
    func manageSortingStatus(isSortingActive: Bool) {
        
    }
    
}
