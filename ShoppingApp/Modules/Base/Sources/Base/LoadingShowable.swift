//
//   LoadingShowable.swift
//
//
//  Created by Ezgi Sümer Günaydın on 17.07.2024.
//

import Foundation
import UIKit

// MARK: - LoadingShowable Protocol
protocol LoadingShowable where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}
