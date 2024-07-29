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
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var initialImage: UIImage?
    private var secondImage: UIImage?
    private var textContent: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
        
    final func setup() {
        imageView.image = initialImage
        descriptionLabel.text = textContent
    }
    
    @IBAction func topButtonClicked(_ sender: Any) {
        print("tıklandı")
    }
}

public extension CheckBoxView {
    final func configureWith(
        initialImage: UIImage,
        secondImage: UIImage,
        textContent: String
    ) {
        self.initialImage = initialImage
        self.secondImage = secondImage
        self.textContent = textContent
        setup()
    }
    
    final func configureWithBoldText(
            initialImage: UIImage,
            secondImage: UIImage,
            fullText: String,
            boldPart: String,
            target: Any,
            action: Selector
        ) {
            self.initialImage = initialImage
            self.secondImage = secondImage
            self.textContent = fullText
            setup()
            descriptionLabel.setBoldAndClickableText(fullText: fullText, clickablePart: boldPart, target: target, action: action)
        }
}
