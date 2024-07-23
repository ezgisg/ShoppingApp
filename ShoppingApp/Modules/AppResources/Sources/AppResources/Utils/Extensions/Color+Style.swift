//
//  Color+Style.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation
import UIKit.UIColor

public extension UIColor {
    var dividerColor: UIColor {
        UIColor(named: "dividerColor", in: Bundle.module, compatibleWith: .current) ?? .systemGray
    }
    
    var buttonColor: UIColor? {
        UIColor(named: "buttonColor", in: Bundle.module, compatibleWith: .current)
    }
    
    var textColor: UIColor {
        UIColor(named: "textColor", in: Bundle.module, compatibleWith: .current) ?? .black
    }
    
}
