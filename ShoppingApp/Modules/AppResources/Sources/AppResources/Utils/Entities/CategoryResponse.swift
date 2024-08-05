//
//  CategoryResponse.swift
//
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import Foundation

public struct CategoryResponseElement: Hashable {
    public let id: UUID
    public let value: String?
    public let imagePath: String?

    public init(value: String, imagePath: String) {
        self.id = UUID()
        self.value = value
        self.imagePath = imagePath
    }
}



// MARK: - Alias
public typealias CategoryResponse = [CategoryResponseElement]
public typealias CategoryResult = Result<CategoryResponse, BaseError>
