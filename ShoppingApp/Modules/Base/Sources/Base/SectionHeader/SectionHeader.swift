//
//  SectionHeader.swift
//
//
//  Created by Ezgi Sümer Günaydın on 4.08.2024.
//

import Foundation
import UIKit

public class SectionHeader: UICollectionReusableView {
    public static let reuseIdentifier = "SectionHeader"
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with title: String, color: UIColor, backgroundColor: UIColor? = .white, leading: CGFloat? = 0) {
        self.backgroundColor = backgroundColor
        titleLabel.text = title
        titleLabel.textColor = color
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading ?? 0)
        ])
    }
}
