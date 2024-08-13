//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation
import UIKit.UIImage

public extension UIImage {
    static var loginImage: UIImage? {
        return UIImage(named: "login", in: Bundle.module, compatibleWith: .current)
    }
    
    static var passwordHideImage: UIImage? {
        return UIImage(named: "passwordHide", in: Bundle.module, compatibleWith: .current)
    }
    
    static var passwordShowImage: UIImage? {
        return UIImage(named: "passwordShow", in: Bundle.module, compatibleWith: .current)
    }
    
    static var tabbarCircle: UIImage? {
        return UIImage(named: "tabbarCircle", in: Bundle.module, compatibleWith: .current)
    }
    
    static var tabbarCircleSelected: UIImage? {
        return UIImage(named: "tabbarCircleSelected", in: Bundle.module, compatibleWith: .current)
    }
    
    static var splashImage: UIImage? {
        return UIImage(named: "splashImage", in: Bundle.module, compatibleWith: .current)
    }
    
    static var systemCircleImage: UIImage? {
        return UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
    }
    
    static var welcomeImage: UIImage {
        return UIImage(named: "welcomeImage", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var browseImage: UIImage {
        return UIImage(named: "browseImage", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var checkoutImage: UIImage {
        return UIImage(named: "checkoutImage", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var registerImage: UIImage {
        return UIImage(named: "registerImage", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var check: UIImage {
        return UIImage(named: "check", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var uncheck: UIImage {
        return UIImage(named: "uncheck", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var profile: UIImage {
        return UIImage(named: "profile", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var bigLayout: UIImage {
        return UIImage(named: "bigLayout", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var smallLayout: UIImage {
        return UIImage(named: "smallLayout", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var filter: UIImage {
        return UIImage(named: "filter", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var sorting: UIImage {
        return UIImage(named: "sorting", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var noImage: UIImage {
        return UIImage(named: "noImage", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
    static var detailCategory: UIImage {
        return UIImage(named: "detailCategory", in: Bundle.module, compatibleWith: .current) ?? UIImage()
    }
    
}
