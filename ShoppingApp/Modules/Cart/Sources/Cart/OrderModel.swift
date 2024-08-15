//
//  OrderModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 13.08.2024.
//

import Foundation

public struct OrderModel: Decodable {
    let id: Int?
    let userId: Int?
    let date: String?
    let products: [Cart]?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case date
        case products
        case version = "__v"
    }
}

public struct Cart: Decodable, Hashable {
    let productId: Int?
    let size: String?
    var quantity: Int?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(productId)
    }

}
