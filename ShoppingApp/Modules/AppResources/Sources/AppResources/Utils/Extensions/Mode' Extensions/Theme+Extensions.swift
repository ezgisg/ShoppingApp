//
//  Theme+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

//TODO: Düzenlenecek

import UIKit

// MARK: - UIColor
public extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            }
            return light
        }
    }
}

// MARK: - UIImageAsset
public extension UIImageAsset {
    convenience init(lightModeImage: UIImage?, darkModeImage: UIImage?) {
        self.init()
        register(lightModeImage: lightModeImage, darkModeImage: darkModeImage)
    }

    func register(lightModeImage: UIImage?, darkModeImage: UIImage?) {
        register(lightModeImage, for: .init(userInterfaceStyle: .light))
        register(darkModeImage, for: .init(userInterfaceStyle: .dark))
    }

    func register(_ image: UIImage?, for traitCollection: UITraitCollection) {
        guard let image else {
            return
        }
        register(image, with: traitCollection)
    }

    func image() -> UIImage {
        image(with: .current)
    }
}


// MARK: - Storage of Theme
public extension UserDefaults {
    var overridedUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            UIUserInterfaceStyle(rawValue: integer(forKey: #function)) ?? .unspecified
        }
        set {
            set(newValue.rawValue, forKey: #function)
        }
    }
}

// MARK: - Override of Theme
public extension UIApplication {
    func override(_ userInterfaceStyle: UIUserInterfaceStyle) {
        if supportsMultipleScenes {
            for connectedScene in connectedScenes {
                if let scene = connectedScene as? UIWindowScene {
                    for window in scene.windows {
                        window.overrideUserInterfaceStyle = userInterfaceStyle
                    }
                }
            }
        } else {
            for window in windows {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    }
}
