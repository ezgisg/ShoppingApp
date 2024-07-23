//
//  EmptyView.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 19.07.2024.
//

import Foundation
import UIKit

// MARK: - EmptyView
public class EmptyView: UIView {
    

    private let label = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
    }
    
    private func setupViews() {
        addSubview(label)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }

    public func configure(with title: String) {
        label.text = title
    }
    
}


