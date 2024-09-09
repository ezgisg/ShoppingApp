//
//  ProductListMockDataProvider.swift
//
//
//  Created by Ezgi Sümer Günaydın on 9.09.2024.
//

import AppResources
import Foundation
@testable import ProductList

final class ProductListMockDataProvider {
    // MARK: - Init
    init() { }
    
    // MARK: - Static Methods
    static let allProductsSuccessData = MockDataProvider().getJSONData(
        from: "allProducts_success_response",
        type: ProductListResponse.self,
        on: Bundle.module
    )
    
}

final public class MockDataProvider {
    // MARK: - Init
    public init() { }

    // MARK: - Method
    public func getJSONData<T>(
        from resource: String,
        type: T.Type,
        on bundle: Bundle
    ) -> T? where T: Decodable & Encodable {
        var model: T?
        
        guard
            let fileUrl = bundle.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: fileUrl)
        else {
            debugPrint("\(resource) file not found")
            return nil
        }
        
        do {
            model = try JSONDecoder().decode(type, from: data)
        } catch {
            debugPrint("Decoding error: \(error.localizedDescription)")
        }
        
        return model
    }
    
}
