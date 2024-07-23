//
//  Color+Style.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation
import UIKit.UIColor

public extension UIColor {
    static var dividerColor: UIColor {
        UIColor(named: "dividerColor", in: Bundle.module, compatibleWith: .current) ?? .systemGray
    }
    
    static var buttonColor: UIColor? {
        UIColor(named: "buttonColor", in: Bundle.module, compatibleWith: .current)
    }
    
    static var textColor: UIColor {
        UIColor(named: "textColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
    
    static var backgroundColor: UIColor {
        UIColor(named: "backgroundColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
    
    static var lightTextColor: UIColor {
        UIColor(named: "lightTextColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
    
    static var buttonTextColor: UIColor {
        UIColor(named: "buttonTextColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
    
    static var warningTextColor: UIColor {
        UIColor(named: "warningTextColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
}

