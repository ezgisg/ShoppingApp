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
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var initialImage: UIImage?
    private var secondImage: UIImage?
    private var textContent: String?
    private var boldContent: String?
    private var isCheckBoxImageNeeded: Bool?
    
    
    var onImageTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
        
    final func setup() {
        imageContainerView.isHidden = !(isCheckBoxImageNeeded ?? true)
        imageView.isHidden = !(isCheckBoxImageNeeded ?? true)
        imageView.image = initialImage
        descriptionLabel.setBoldText(fullText: textContent ?? "", boldPart: boldContent ?? "")
        setupGestureRecognizers()
        imageView.layer.borderWidth = 3
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 3

    }
    
    private func setupGestureRecognizers() {
         let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
         imageView.isUserInteractionEnabled = true
         imageView.addGestureRecognizer(imageTapGesture)
         
         let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
         descriptionLabel.isUserInteractionEnabled = true
         descriptionLabel.addGestureRecognizer(labelTapGesture)
     }
     
     @objc private func imageTapped() {
         print("ImageView tapped")
         if imageView.image == initialImage {
                   imageView.image = secondImage
               } else {
                   imageView.image = initialImage
               }
               onImageTapped?()
     }
     
     @objc private func labelTapped() {
         print("DescriptionLabel tapped")
     }
    

}

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
