//
//  HomeModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Foundation

struct BannerData: Decodable {
    let language: String?
    let elements: [Element]?
}

struct Element: Decodable {
    let id: Int?
    let type: String?
    let title: String?
    let subtitle: String?
    let items: [Item]?
}

struct Item: Decodable {
    let id: Int?
    let name: String?
    let subheading: String?
    let image: String?
}
