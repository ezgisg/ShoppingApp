//
//  CustomInformationView.swift
//
//
//  Created by Ezgi Sümer Günaydın on 31.07.2024.
//

import AppResources
import Foundation
import UIKit

// MARK: - CustomInformationView
public class CustomInformationView: UIView, NibOwnerLoadable {
    
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var outsideTapButton: UIButton!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Private Variables
    private var messageTitle: String?
    private var message: String?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupUI()
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
       self.isHidden = true
    }
    
    @IBAction func didTapOutsideButton(_ sender: Any) {
        self.isHidden = true
    }
}

// MARK: - Setup
private extension CustomInformationView {
    final func setupUI() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .buttonColor
        containerView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        containerView.layer.borderWidth = 2
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .backgroundColor
        textView.textColor = .textColor
        textView.text = message
        title.text = messageTitle
        title.textColor = .buttonTextColor
        
        cancelButton.tintColor = .buttonTextColor
        

        textViewHeightConstraint.constant = textView.updateHeightToFitContent(max: 200)
        backgroundColor = .black.withAlphaComponent(0.2)
    }
    
}

// MARK: - Configure
public extension CustomInformationView {
    final func configureWith(message: String, messageTitle: String) {
        self.message = message
        self.messageTitle = messageTitle
        setupUI()
    }
}


extension UITextView {
    func updateHeightToFitContent(max: Double) -> Double {
   
        let contentHeight = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        // Yüksekliği güncelle
        var frame = self.frame
        frame.size.height = min(contentHeight, max)
        self.frame = frame
        return min(contentHeight, max)
    }
}
