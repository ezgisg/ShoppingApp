//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation

// MARK: - Typealias
public typealias L10nGeneric = GenericLocalizableKey

// MARK: - GenericLocalizableKey
public enum GenericLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }

    // MARK: - Keys
    
    case error
    case unknownError
    case ok = "generic.okay"
    case abort = "generic.abort"
    case home
    case categories
    case basket
    case favorites
    case appName
    
    case email
    case password
    case passwordConfirm
    case name
    case surname
    case emailWarning
    
    case searchCategories
    case allCategories
    
    case sorting
    case filter
    case delete
    case clean
    case selectAll
    case list
    case discover
    case keepShopping
    case addToCart
    case apply
    case applied
    case againTry
    
    case campaigns
    case campaignDetails
    case products
    case noResult
    case points
    
    public enum PasswordControlMessages: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case number = "PasswordControlMessages.number"
        case letter = "PasswordControlMessages.letter"
        case special = "PasswordControlMessages.special"
        case consecutive = "PasswordControlMessages.consecutive"
        case repeating = "PasswordControlMessages.repeating"
        case minCharacter = "PasswordControlMessages.minCharacter"
        case maxCharacter = "PasswordControlMessages.maxCharacter"
        case nameContain = "PasswordControlMessages.nameContain"
        case surnameContain = "PasswordControlMessages.surnameContain"
    }
    
    public enum CampaignMessages: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case CampaignMessages1 = "CampaignMessages.1"
        case CampaignMessages2 = "CampaignMessages.2"
        case CampaignMessages3 = "CampaignMessages.3"
        case CampaignMessages4 = "CampaignMessages.4"
        case CampaignMessages5 = "CampaignMessages.5"
        case CampaignMessages6 = "CampaignMessages.6"
    }
    
    public enum FilterWarnings: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case clean = "FilterWarnings.clean"
        case cleanMessages = "FilterWarnings.cleanMessages"
    }
    
    public enum FavoritesWarnings: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case title = "FavoritesWarnings.title"
        case detail = "FavoritesWarnings.detail"
    }
    
    public enum CartWarnings: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case title = "CartWarnings.title"
        case detail = "CartWarnings.detail"
    }
    
    public enum CouponWarnings: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case notValid = "CouponWarnings.notValid"
        case valid = "CouponWarnings.valid"
        case code = "CouponWarnings.code"
    }
    
    public enum SortOptions: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case rating = "SortOptions.rating"
        case price = "SortOptions.price"
        case category = "SortOptions.category"
        
        case highToLow = "SortOptions.highToLow"
        case lowToHigh = "SortOptions.lowToHigh"
        case suggested = "SortOptions.suggested"
    }
    
    public enum CartTexts: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case speedReview = "CartTexts.speedReview"
        case variant = "CartTexts.variant"
        case goToDetail = "CartTexts.goToDetail"
        case addedToCart = "CartTexts.addedToCart"
        case titleProductDescription = "CartTexts.titleProductDescription"
        case titlePaymentTypes = "CartTexts.titlePaymentTypes"
        case titleSuggestionsForYou = "CartTexts.titleSuggestionsForYou"
        case similarProducts = "CartTexts.similarProducts"
        case deleteSelecteds = "CartTexts.deleteSelecteds"
        
        case goToPayment = "CartTexts.goToPayment"
        case orderSummary = "CartTexts.orderSummary"
        case total = "CartTexts.total"
        case discounts = "CartTexts.discounts"
        case subTotal = "CartTexts.subTotal"
        case cargoFee = "CartTexts.cargoFee"
        case orderInfo = "CartTexts.orderInfo"
        case grandTotal = "CartTexts.grandTotal"
        case totalDiscount = "CartTexts.totalDiscount"
        
    }
    
    public enum fetchingProductError: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
    
        case title = "fetchingProductError.title"
        case message = "fetchingProductError.message"
    }
    
    public enum paymentOptions: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
    
        case cashAtDelivery = "paymentOptions.cashAtDelivery"
        case creditBankCard = "paymentOptions.creditBankCard"
        case masterpass = "paymentOptions.masterpass"
    }
    
}

// MARK: - Functions
extension LocalizableProtocol {
    public func localized() -> String {
        return stringValue.localized()
    }
}
