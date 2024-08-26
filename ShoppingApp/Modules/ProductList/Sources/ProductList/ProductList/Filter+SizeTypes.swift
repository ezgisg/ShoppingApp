//
//  FilterTypes.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 11.08.2024.
//

import AppResources
import Foundation

///Unfortunately all filter options defined statically on screens because there is no backend to fetch data and to keep user selections
///Using enums to conveniently manage localizable
//MARK: - Enums
//MARK: - FilterOption
public enum FilterOption: Int, CaseIterable {
    case rating = 0
    case price = 1
    case category = 2
    
    var stringValue: String {
        switch self {
        case .rating:
            return L10nGeneric.SortOptions.rating.localized()
        case .price:
            return L10nGeneric.SortOptions.price.localized()
        case .category:
            return L10nGeneric.SortOptions.category.localized()
        }
    }
}

//MARK: - RatingOption
public enum RatingOption: Double, CaseIterable {
    case zeroPlus = 0.0
    case onePlus = 1.0
    case twoPlus = 2.0
    case threePlus = 3.0
    case fourPlus = 4.0

    var stringValue: String {
        switch self {
        case .zeroPlus:
            return "0 - 1 \(L10nGeneric.points.localized())"
        case .onePlus:
            return "1 - 2 \(L10nGeneric.points.localized())"
        case .twoPlus:
            return "2 - 3 \(L10nGeneric.points.localized())"
        case .threePlus:
            return "3 - 4 \(L10nGeneric.points.localized())"
        case .fourPlus:
            return "4 - 5 \(L10nGeneric.points.localized())"
        }
    }
}

enum ProductListScreenSectionType: Int, CaseIterable, Hashable {
    case filter = 0
    case products = 1
    
    var stringValue: String? {
         switch self {
         case .filter:
             return L10nGeneric.filter.localized()
         case .products:
             return L10nGeneric.products.localized()
         }
     }
}

//MARK: - Price Options
public enum PriceOption: Int, CaseIterable {
    case oneToTen = 1
    case tenToHundred = 10
    case hundredPlus = 100
    
    var stringValue: String {
        switch self {
        case .oneToTen:
            return "1 - 10 $"
        case .tenToHundred:
            return "10 - 100 $"
        case .hundredPlus:
            return "100+ $"
        }
    }
}
