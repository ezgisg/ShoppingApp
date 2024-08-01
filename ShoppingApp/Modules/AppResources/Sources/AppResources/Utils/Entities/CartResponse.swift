//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

public struct CartResponse: Decodable {
    let id: Int?
    let userId: Int?
    let products: [cartProduct]?
}

public struct cartProduct: Decodable {
    let productId: Int?
    let quantity: Int?
}


// MARK: - Alias
public typealias CartResult = Result<[CartResponse], BaseError>
