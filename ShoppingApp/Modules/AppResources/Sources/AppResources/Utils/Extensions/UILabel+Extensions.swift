//
//  UILabel+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import Foundation
import UIKit

public extension UILabel {
    func setBoldText(fullText: String, boldPart: String) {
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let boldRange = (fullText as NSString).range(of: boldPart)
        
        // Set the bold attributes
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)], range: boldRange)
        
        self.attributedText = attributedString
    }
}
