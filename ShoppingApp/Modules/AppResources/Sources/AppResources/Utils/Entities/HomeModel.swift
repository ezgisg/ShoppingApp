//
//  HomeModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

public struct BannerData: Decodable {
    public let language: String?
    public let elements: [Element]?
}

public struct Element: Decodable {
    public let id: Int?
    public let type: String?
    public let title: String?
    public let subtitle: String?
    public let items: [Item]?
}

public struct Item: Decodable {
    public let id: Int?
    public let name: String?
    public let subheading: String?
    public let image: String?
}
