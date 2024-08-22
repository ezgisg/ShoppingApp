//
//  CartBottomProductCollectionViewCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import UIKit

public final class CartBottomProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var addToCartLabel: UILabel!
    
    // MARK: - Properties
    public var onAddToCartTapped: (() -> Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

}

extension CartBottomProductCollectionViewCell {
    public func configureWith(product: ProductResponseElement) {
        loadProductImage(from: product.image)
        nameLabel.text = product.title ?? "N/A"
        updatePriceLabel(price: product.price)
    }
}


//MARK: - Helpers
private extension CartBottomProductCollectionViewCell {
    final func loadProductImage(from urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else {
            return imageView.image = .noImage
        }
        imageView.loadImage(with: url, cornerRadius: 8, contentMode: .scaleAspectFit)
    }
    
    final func updatePriceLabel(price: Double?) {
        guard let price else {
            return priceLabel.text = "N/A"
        }
        priceLabel.text = "\(price) $"
    }
}

//MARK: - Setups
private extension CartBottomProductCollectionViewCell {
    final func setupUI() {
        imageContainerView.layer.borderColor = UIColor.lightDividerColor.cgColor
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.cornerRadius = 8
        
        addToCartView.backgroundColor = .tabbarBackgroundColor
        addToCartView.layer.cornerRadius = 8
        //TODO: localizable
        addToCartLabel.text = "Sepete Ekle"
        addToCartLabel.textColor = .white
        addToCartLabel.adjustsFontSizeToFitWidth = true
        
        addTapGesture()
    }
    
    final func addTapGesture() {
        let addToCartGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAddToCart))
        addToCartView.addGestureRecognizer(addToCartGesture)
        addToCartView.isUserInteractionEnabled = true
    }
    
    @objc final func tappedAddToCart() {
        onAddToCartTapped?()
    }
}
