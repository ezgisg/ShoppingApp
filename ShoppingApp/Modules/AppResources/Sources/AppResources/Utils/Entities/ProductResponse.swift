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
    public var quantity: Int?
    public var size: String?
    public var isSelected: Bool?
    
    init(id: Int?, title: String?, price: Double?, description: String?, category: String?, image: String?, rating: Rating?, quantity: Int? = nil, size: String? = nil, isSelected: Bool? = true) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = category
        self.image = image
        self.rating = rating
        self.quantity = quantity
        self.size = size
        self.isSelected = isSelected
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(id ?? 0)\(size ?? "-")")
    }
    
}

public struct Rating: Equatable, Decodable {
    public let rate: Double?
    public let count: Int?
}


// MARK: - Alias
public typealias ProductListResponse = [ProductResponseElement]
public typealias ProductListResult = Result<ProductListResponse, BaseError>
public typealias ProductResult = Result<ProductResponseElement, BaseError>
