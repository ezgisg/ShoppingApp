// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class Components {
    /// - `AppResources` shared instance
    public static var shared = Components()

    public static let bundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: Components.self)
#endif
    }()

    // MARK: - Init
    private init() {
      
    }
}

