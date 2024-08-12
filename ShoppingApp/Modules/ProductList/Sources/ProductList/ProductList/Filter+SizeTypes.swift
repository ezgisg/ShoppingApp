//
//  FilterTypes.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 11.08.2024.
//

import Foundation
//TODO: Localizable for texts
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
            return "Rating"
        case .price:
            return "Price"
        case .category:
            return "Category"
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
            return "0 - 1 Puan Arası"
        case .onePlus:
            return "1 - 2 Puan Arası"
        case .twoPlus:
            return "2 - 3 Puan Arası"
        case .threePlus:
            return "3 - 4 Puan Arası"
        case .fourPlus:
            return "4 - 5 Puan Arası"
        }
    }
}

enum ProductListScreenSectionType: Int, CaseIterable, Hashable {
    case filter = 0
    case products = 1
    
    var stringValue: String? {
         switch self {
         case .filter:
             return "Filter"
         case .products:
             return "Products"
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
