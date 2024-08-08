//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 17.07.2024.
//

import Foundation
import UIKit

// MARK: - LoadingView
class LoadingView {
   
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let shared = LoadingView()
    var blurView: UIVisualEffectView = UIVisualEffectView()
    
    private init() {
        configure()
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .gray
        blurView.contentView.addSubview(activityIndicator)
    }
    
    func startLoading() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: window.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
    }
    
    func hideLoading() {
        blurView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}

