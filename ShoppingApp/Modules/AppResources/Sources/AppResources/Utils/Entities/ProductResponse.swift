//
//  ProductResponse.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

public struct ProductResponseElement: Decodable, Hashable {
    
    public let id: Int?
    public let title: String?
    public let price: Double?
    public let description: String?
    public let category: String?
    public let image: String?
    public let rating: Rating?
    
    public static func == (lhs: ProductResponseElement, rhs: ProductResponseElement) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

public struct Rating: Decodable {
    public let rate: Double?
    public let count: Int?
}


// MARK: - Alias
public typealias ProductListResponse = [ProductResponseElement]
public typealias ProductListResult = Result<ProductListResponse, BaseError>
public typealias ProductResult = Result<ProductResponseElement, BaseError>
