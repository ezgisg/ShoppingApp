//
//  CartProductCollectionViewCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import UIKit

class CartProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topImageView: UIView!
    @IBOutlet weak var containerImage: UIImageView!
    @IBOutlet weak var outerImage: UIImageView!
    @IBOutlet weak var innerImage: UIImageView!

    @IBOutlet weak var backgroundOfImageView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var discountedPriceLabel: UILabel!

    @IBOutlet weak var minusButtonImage: UIImageView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var productCountBackgroundView: UIView!
    @IBOutlet weak var plusButtonImage: UIImageView!
    @IBOutlet weak var minusPlusBackView: UIView!
    
    // MARK: - Properties
    var onSelectionTapped: (() -> Void)?
    
    var product: ProductResponseElement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        addTapGesture()
        // Initialization code
    }

}

//MARK: - Configure
extension CartProductCollectionViewCell {
    func configureWith(product: ProductResponseElement, discountedPrice: Int?) {
        self.product = product
        if let discountedPrice {
        
            discountedPriceLabel.text = String(discountedPrice)
            discountedPriceLabel.isHidden = false
            priceLabel.font = .systemFont(ofSize: priceLabel.font.pointSize - 4)
            priceLabel.textColor = .gray
            let attributedText = NSAttributedString(string: priceLabel.text ?? "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            priceLabel.attributedText = attributedText
        } else {
            discountedPriceLabel.isHidden = true
            priceLabel.font = .boldSystemFont(ofSize: priceLabel.font.pointSize + 4)
            priceLabel.textColor = .black
            priceLabel.attributedText = NSAttributedString(string: priceLabel.text ?? "")
        }
        
        productName.text = product.title
        productCategory.text = product.category
        if let quantity = product.quantity {
            productCountLabel.text = String(quantity)
        } else {
            productCountLabel.text = "N/A"
        }

        
        if let price = product.price,
           let quantity = product.quantity {
            priceLabel.text = String(price * Double(quantity))
        } else {
            priceLabel.text = "N/A"
        }
        productSize.text = product.size
     
    
        guard let urlString = product.image, let url = URL(string: urlString)
        else { return productImage.image = .noImage }
        productImage.loadImage(with: url, cornerRadius: 8, contentMode: .scaleAspectFit)
    }
}

//MARK: - Setups
extension CartProductCollectionViewCell {
    final func setup() {
        minusButtonImage.image = .minusImage
        minusButtonImage.tintColor = .tabbarBackgroundColor
        plusButtonImage.image = .plusImage
        plusButtonImage.tintColor = .tabbarBackgroundColor
        
        productCountLabel.adjustsFontSizeToFitWidth = true
        productCountLabel.textColor = .white
        
        productCountBackgroundView.backgroundColor = .tabbarBackgroundColor.withAlphaComponent(0.5)
        productCountBackgroundView.layer.cornerRadius = productCountBackgroundView.frame.width / 2
        
        minusPlusBackView.layer.cornerRadius = 8
        minusPlusBackView.layer.borderColor = UIColor.tabbarBackgroundColor.cgColor
        minusPlusBackView.layer.borderWidth = 1
        
        //TODO: bu buton hem sortda var hem burada var view ortaklaştırılacak
        topImageView.backgroundColor = .clear
        containerImage.image = .systemCircleImage
        containerImage.tintColor = .tabbarBackgroundColor
        outerImage.image = .systemCircleImage
        outerImage.tintColor = .white
        innerImage.image = .systemCircleImage
        innerImage.tintColor = .tabbarBackgroundColor
        
        backgroundOfImageView.backgroundColor = .clear
        backgroundOfImageView.layer.borderWidth = 1
        backgroundOfImageView.layer.borderColor = UIColor.lightDividerColor.cgColor
        backgroundOfImageView.layer.cornerRadius = 8
    }
    
    private func addTapGesture() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
         innerImage.addGestureRecognizer(tapGesture)
         innerImage.isUserInteractionEnabled = true
     }
     
     @objc private func handleTap() {
         product?.isSelected?.toggle()
         print("*****", product?.isSelected)
         innerImage.tintColor = product?.isSelected ?? true ? .tabbarBackgroundColor : .white
         onSelectionTapped?()
     }
}
