//
//  FooterView.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import UIKit

class FooterView: UICollectionReusableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var decorationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configureWith(text: String) {
        label.text = text.capitalizingEachWord()
    }
    
    func setupUI() {
        label.textColor = .tabbarBackgroundColor
        label.layer.opacity = 0.7
        containerView.backgroundColor = .clear
        decorationLabel.textColor = .tabbarBackgroundColor
        decorationLabel.layer.opacity = 0.3
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        //TODO: tüm ürünlere gidecek
        print("tüm ürünler açılacak")
    }
}
