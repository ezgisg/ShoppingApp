//
//  FooterView.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import UIKit
import ProductList

class FooterView: UICollectionReusableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var decorationLabel: UILabel!
    
    var buttonTappedAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configureWith(text: String, buttonTappedAction: @escaping () -> Void) {
         label.text = text.capitalizingEachWord()
         self.buttonTappedAction = buttonTappedAction
     }
    
    func setupUI() {
        label.textColor = .tabbarBackgroundColor
        label.layer.opacity = 0.7
        containerView.backgroundColor = .clear
        decorationLabel.textColor = .tabbarBackgroundColor
        decorationLabel.layer.opacity = 0.3
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        buttonTappedAction?()
    }
}
