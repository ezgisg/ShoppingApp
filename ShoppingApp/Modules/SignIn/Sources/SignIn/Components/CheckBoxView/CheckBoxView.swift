//
//  CheckBoxView.swift
//
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import Foundation
import UIKit

// MARK: - CheckBoxView
public class CheckBoxView: UIView, NibOwnerLoadable {
    
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - Outlets
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Private Variables
    private var initialImage: UIImage?
    private var secondImage: UIImage?
    private var textContent: String = ""
    private var boldContent: String = ""
    private var isCheckBoxImageNeeded: Bool = false
    
    var onImageTapped: (() -> Void)?
    var onTextTapped: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
}

// MARK: - Setups
private extension CheckBoxView {
    final func setup() {
        imageContainerView.isHidden = !isCheckBoxImageNeeded
        imageView.image = initialImage
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = 3
        imageView.backgroundColor = .white
        descriptionLabel.setBoldText(fullText: textContent, boldPart: boldContent)
        setupGestureRecognizers()
    }
    
    final func setupGestureRecognizers() {
         let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
         imageView.isUserInteractionEnabled = true
         imageView.addGestureRecognizer(imageTapGesture)
         
         let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
         descriptionLabel.isUserInteractionEnabled = true
         descriptionLabel.addGestureRecognizer(labelTapGesture)
     }
     
    @objc final func imageTapped() {
        imageView.image = (imageView.image == initialImage) ? secondImage : initialImage
        onImageTapped?()
    }
     
     @objc final func labelTapped() {
        onTextTapped?()
     }
}

// MARK: - Configure
public extension CheckBoxView {
    final func configureWith(
        initialImage: UIImage,
        secondImage: UIImage,
        textContent: String,
        boldContent: String,
        isCheckBoxImageNeeded: Bool
    ) {
        self.initialImage = initialImage
        self.secondImage = secondImage
        self.textContent = textContent
        self.boldContent = boldContent
        self.isCheckBoxImageNeeded = isCheckBoxImageNeeded
        setup()
    }
}
