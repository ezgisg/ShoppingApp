//
//  CollectionView+Extensions.swift
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//
//
import Foundation
import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}


//MARK: - UICollectionView
public extension UICollectionView {

    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    func register<T: UICollectionViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundle: Bundle? = nil) {
        let identifier = String(describing: name)
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T else { fatalError("can not dequeue cell \(type)") }
        return cell
    }
    
    func registerReusableView<T: UICollectionReusableView>(nibWithViewClass name: T.Type, forSupplementaryViewOfKind kind: String, at bundle: Bundle? = nil) {
            let identifier = String(describing: name)
            register(
                UINib(nibName: identifier, bundle: bundle),
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: identifier
            )
        }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
            ofKind kind: String,
            withClass name: T.Type,
            for indexPath: IndexPath
        ) -> T {
            guard let cell = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: name),
                for: indexPath) as? T else {
                fatalError(
                    """
                    Couldn't find UICollectionReusableView for \(String(describing: name)),
                    make sure the view is registered with collection view
                    """)
            }
            return cell
        }
    
  
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                """
                Couldn't find UICollectionViewCell for \(String(describing: name)),
                make sure the cell is registered with collection view
                """)
        }
        return cell
    }
    
}

