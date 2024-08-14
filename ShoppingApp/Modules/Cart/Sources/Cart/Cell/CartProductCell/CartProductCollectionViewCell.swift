//
//  CartProductCollectionViewCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import UIKit

class CartProductCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButtonImage: UIImageView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var productCountBackgroundView: UIView!
    @IBOutlet weak var plusButtonImage: UIImageView!
    @IBOutlet weak var minusPlusBackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//MARK: - Configure
extension CartProductCollectionViewCell {
    func configureWith(product: ProductResponseElement) {
        productName.text = product.title
        if let price = product.price {
            priceLabel.text = String(price)
        } else {
            priceLabel.text = "N/A"
        }

        productSize.text = product.size
        selectionImage.image = .tabbarCircleSelected
        minusButtonImage.image = .minusImage
        plusButtonImage.image = .plusImage
        minusButtonImage.tintColor = .tabbarBackgroundColor
        plusButtonImage.tintColor = .tabbarBackgroundColor
        minusPlusBackView.layer.cornerRadius = 8
        minusPlusBackView.layer.borderColor = UIColor.tabbarBackgroundColor.cgColor
        minusPlusBackView.layer.borderWidth = 1
        productCountBackgroundView.backgroundColor = .tabbarBackgroundColor.withAlphaComponent(0.5)
        productCountBackgroundView.layer.cornerRadius = productCountBackgroundView.frame.width / 2
        
        guard let urlString = product.image, let url = URL(string: urlString)
        else { return productImage.image = .noImage }
        productImage.loadImage(with: url, contentMode: .scaleAspectFit)
    }
}
