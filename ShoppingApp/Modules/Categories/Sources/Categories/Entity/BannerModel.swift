//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import Foundation

public struct BannerElement: Hashable {
    public let id: UUID
    public let imagePath: String?

    public init(imagePath: String) {
        self.id = UUID()
        self.imagePath = imagePath
    }
}
