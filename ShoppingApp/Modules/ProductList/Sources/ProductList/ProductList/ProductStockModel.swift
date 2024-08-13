//
//  ProductStockModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import Foundation

struct ProductsResponse: Decodable {
    let products: [ProductStockModel]
}

struct ProductStockModel: Decodable {
    let id: Int
    let sizes: [Size]
}

struct Size: Decodable {
    let size: String
    let stock: Int
}
