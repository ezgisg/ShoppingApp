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
    
    @IBOutlet weak var plusButtonImage: UIImageView!
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
        minusButtonImage.image = .profile
        plusButtonImage.image = .profile
        
        guard let urlString = product.image, let url = URL(string: urlString)
        else { return productImage.image = .noImage }
        productImage.loadImage(with: url, contentMode: .scaleAspectFit)
    }
}
