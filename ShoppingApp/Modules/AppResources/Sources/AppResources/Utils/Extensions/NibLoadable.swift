//
//  NibLoadable.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import Foundation
import UIKit

// MARK: Protocol Definition
/// Make your UIView subclasses conform to this protocol when:
///  * they are NIB-based, and
///  * this class is used as the XIB's root view
///
/// to be able to instantiate them from the NIB in a type-safe manner
public protocol NibLoadable: AnyObject {
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
    
    static var module: Bundle { get set }
}

// MARK: Default implementation
public extension NibLoadable {
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: module)
    }
    
    static var module: Bundle {
        return Bundle.module
    }
}

// MARK: Support for instantiation from NIB
public extension NibLoadable where Self: UIView {
    /**
     Returns a UIView object instantiated from nib
     - returns: A NibLoadable, UIView instance
     */
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        view.backgroundColor = .clear
        return view
    }
}
