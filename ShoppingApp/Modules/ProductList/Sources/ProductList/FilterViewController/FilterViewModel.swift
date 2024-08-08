//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import Foundation

//MARK: - Enums
enum RatingOption: Int, CaseIterable {
    case twoPlus = 2
    case threePlus = 3
    case fourPlus = 4
    
    var stringValue: String {
        switch self {
        case .twoPlus:
            return "2+"
        case .threePlus:
            return "3+"
        case .fourPlus:
            return "4+"
        }
    }
}

//MARK: - Price Options
enum PriceOption: Int, CaseIterable {
    case oneToTen = 1
    case tenToHundred = 10
    case hundredPlus = 100
    
    var stringValue: String {
        switch self {
        case .oneToTen:
            return "1-10"
        case .tenToHundred:
            return "10-100"
        case .hundredPlus:
            return "100+"
        }
    }
}

//MARK: - Category Options
enum CategoryOption: String, CaseIterable {
    case men
    case women
    case jewelery
    case electronics
    
    var stringValue: String {
        switch self {
        case .men:
            return "men"
        case .women:
            return "women"
        case .jewelery:
            return "jewelery"
        case .electronics:
            return "electronics"
        }
    }
}

//MARK: - FilterOption
enum FilterOption: Int, CaseIterable {
    case rating = 0
    case price = 1
    case category = 2
    
    var stringValue: String {
        switch self {
        case .rating:
            return "rating"
        case .price:
            return "price"
        case .category:
            return "category"
        }
    }
    
    var options: Any {
        switch self {
        case .rating:
            return RatingOption.allCases
        case .price:
            return PriceOption.allCases
        case .category:
            return CategoryOption.allCases
        }
    }
}

//MARK: - FilterViewModelProtocol
protocol FilterViewModelProtocol: AnyObject {
    var filterTypes: [FilterOption] { get }
    var priceType: [PriceOption] { get }
}

//MARK: - FilterViewModelDelegate
protocol FilterViewModelDelegate: AnyObject {
    
}

//MARK: - FilterViewModel
final class FilterViewModel {
    var filterTypes: [FilterOption] = [.price, .rating, .category]
    var priceType: [PriceOption] = [.oneToTen,.tenToHundred,.hundredPlus]
}

//MARK: - FilterViewModelProtocol
extension FilterViewModel: FilterViewModelProtocol {
    
}
