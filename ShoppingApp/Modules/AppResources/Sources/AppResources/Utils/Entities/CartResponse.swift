//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

public struct CartResponseElement: Decodable {
    let id: Int?
    let userId: Int?
    let date: String?
    let products: [cartProduct]?
    let __v: Int?
}

public struct cartProduct: Decodable {
    let productId: Int?
    let quantity: Int?
}


// MARK: - Alias
public typealias CartListResponse = [CartResponseElement]
public typealias CartListResult = Result<CartListResponse, BaseError>
public typealias CartResult = Result<CartResponseElement, BaseError>
