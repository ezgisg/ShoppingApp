//
//  UIImage+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 24.07.2024.
//

import Foundation
import UIKit.UIImage

public extension UIImage {
    static var systemHouseImage: UIImage? {
        return UIImage(systemName: "house")
    }
    
    static var systemListImage: UIImage? {
        return UIImage(systemName: "list.bullet")
    }
    
    static var systemCartImage: UIImage? {
        return UIImage(systemName: "cart")
    }
    
    static var systemHeartImage: UIImage? {
        return UIImage(systemName: "heart")
    }
    
    static var systemCircleImage: UIImage? {
        return UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
    }
    
}
