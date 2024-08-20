//
//  FavoritesManager.swift
//
//
//  Created by Ezgi Sümer Günaydın on 20.08.2024.
//

import AppResources
import Foundation

public class FavoritesManager {

    private let favoritesKey = "favoriteProducts"

    public static let shared = FavoritesManager()

    private init() {}

    public func toggleFavorite(product: ProductResponseElement) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.id == product.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(product)
        }
        saveFavorites(favorites)
    }

    public func isFavorite(product: ProductResponseElement) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(where: { $0.id == product.id })
    }

    public func getFavorites() -> [ProductResponseElement] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let products = try? JSONDecoder().decode([ProductResponseElement].self, from: data) else {
            return []
        }
        return products
    }

    private func saveFavorites(_ products: [ProductResponseElement]) {
        if let data = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
