//
//  TableView+Extensions.swift
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                """
                Couldn't find UITableViewCell for \(String(describing: name)),
                make sure the cell is registered with table view
                """)
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                """
                Couldn't find UITableViewCell for \(String(describing: name)),
                make sure the cell is registered with table view
                """)
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard
            let headerFooterView = dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: name)) as? T
        else {
            fatalError(
                """
                Couldn't find UITableViewHeaderFooterView for \(String(describing: name)),
                make sure the view is registered with table view
                """)
        }
        return headerFooterView
    }

    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundle: Bundle? = nil) {
        let identifier = String(describing: name)
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    func register(cellsWithClasses cells: [UITableViewCell.Type]) {
        for cell in cells {
            register(cellWithClass: cell)
        }
    }

    func register(nibsWithCellClasses cells: [UITableViewCell.Type]) {
        for cell in cells {
            register(nibWithCellClass: cell)
        }
    }
    
    func reloadData(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0) {
            self.reloadData()
        } completion: { _ in
            completion()
        }
    }
}
