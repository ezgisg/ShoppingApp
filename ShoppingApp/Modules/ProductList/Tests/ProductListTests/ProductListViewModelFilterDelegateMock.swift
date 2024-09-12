//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.09.2024.
//

import Foundation
@testable import ProductList

final class ProductListViewModelFilterDelegateMock: FilterDelegate {
    
    var isControlledButtonStatus: Bool = false
    var isReload: Bool = false
    
    func controlAllButtonStatus() {
        isControlledButtonStatus = true
    }
    
    func reloadTableView() {
        isReload = true
    }
    

}
