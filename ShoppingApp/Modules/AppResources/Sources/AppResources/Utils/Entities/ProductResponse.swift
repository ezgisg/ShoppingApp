//
//  ProductResponse.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

public struct ProductResponse: Decodable {
    let id: Int?
    let title: String?
    let price: Double?
    let description: String?
    let category: String?
    let image: String?
    let rating: [Rating]?
}

public struct Rating: Decodable {
    let rate: Double?
    let count: Int?
}


// MARK: - Alias
public typealias ProductResult = Result<[ProductResponse], BaseError>
