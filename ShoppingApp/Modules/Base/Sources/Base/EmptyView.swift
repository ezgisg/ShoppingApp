//
//  EmptyView.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 19.07.2024.
//

import Foundation
import UIKit

// MARK: - EmptyViewType
public enum EmptyViewType {
    case basic(title: String, titleColor: UIColor = .black, font: UIFont = .boldSystemFont(ofSize: 24))
    case detailed(image: UIImage, title: String, subtitle: String, buttonTitle: String, buttonColor: UIColor, buttonAction: (() -> Void)?)
}

// MARK: - EmptyView
public class EmptyView: UIView {
    private let stackView = UIStackView()
    private let label: UILabel = {
         let label = UILabel()
         label.textAlignment = .center
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private let subtitleLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var actionButton: UIButton = {
        let actionButton = UIButton(type: .roundedRect)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        return actionButton
    }()
    
    private var buttonAction: (() -> Void)?
    
    private var imageContainer: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    
    private var labelContainer: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    
    private var subtitleLabelContainer: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    
    private var buttonContainer: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        
        imageContainer.addSubview(imageView)
        labelContainer.addSubview(label)
        subtitleLabelContainer.addSubview(subtitleLabel)
        buttonContainer.addSubview(actionButton)
        
        stackView.addArrangedSubview(imageContainer)
        stackView.addArrangedSubview(labelContainer)
        stackView.addArrangedSubview(subtitleLabelContainer)
        stackView.addArrangedSubview(buttonContainer)
  
        label.textAlignment = .center
        subtitleLabel.textAlignment = .center
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageContainer.isHidden = true
        labelContainer.isHidden = true
        subtitleLabelContainer.isHidden = true
        buttonContainer.isHidden = true
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: labelContainer.heightAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: labelContainer.widthAnchor),
            label.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.heightAnchor.constraint(equalTo: subtitleLabelContainer.heightAnchor),
            subtitleLabel.widthAnchor.constraint(lessThanOrEqualTo: subtitleLabelContainer.widthAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: subtitleLabelContainer.centerXAnchor),
            subtitleLabel.centerYAnchor.constraint(equalTo: subtitleLabelContainer.centerYAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 40),
            actionButton.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor, multiplier: 0.5),
            actionButton.widthAnchor.constraint(lessThanOrEqualTo: buttonContainer.widthAnchor, constant: -40),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            actionButton.widthAnchor.constraint(greaterThanOrEqualTo: actionButton.titleLabel?.widthAnchor ?? buttonContainer.widthAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor)
            
        ])
            
    }
    
    public func configure(with type: EmptyViewType) {
        switch type {
        case let .basic(title, titleColor, font):
            labelContainer.isHidden = false
            label.text = title
            label.textColor = titleColor
            label.font = font
        case let .detailed(image, title, subtitle, buttonTitle, buttonColor, action):
            imageContainer.isHidden = false
            labelContainer.isHidden = false
            subtitleLabelContainer.isHidden = false
            buttonContainer.isHidden = false
            
            label.textColor = .black
            subtitleLabel.textColor = .black
    
            imageView.image = image
            label.text = title
            label.textColor = buttonColor
            label.font = .boldSystemFont(ofSize: 18)
            
            subtitleLabel.text = subtitle
            subtitleLabel.textColor = buttonColor
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .light)
            
            actionButton.setTitle(buttonTitle, for: .normal)
            actionButton.backgroundColor = buttonColor
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.layer.cornerRadius = 8
            
            buttonAction = action
        }
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }

}


