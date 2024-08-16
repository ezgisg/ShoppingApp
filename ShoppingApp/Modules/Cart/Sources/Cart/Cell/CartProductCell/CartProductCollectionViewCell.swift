//
//  CartProductCollectionViewCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import UIKit

//MARK: - CartProductCollectionViewCell
class CartProductCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var topImageView: UIView!
    @IBOutlet private weak var containerImage: UIImageView!
    @IBOutlet private weak var outerImage: UIImageView!
    @IBOutlet private weak var innerImage: UIImageView!

    @IBOutlet private weak var backgroundOfImageView: UIView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productCategory: UILabel!
    @IBOutlet private weak var productSize: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var discountedPriceLabel: UILabel!

    @IBOutlet private weak var minusButtonImage: UIImageView!
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var productCountBackgroundView: UIView!
    @IBOutlet private weak var plusButtonImage: UIImageView!
    @IBOutlet private weak var minusPlusBackView: UIView!
    
    // MARK: - Properties
    var onSelectionTapped: (() -> Void)?
    var onMinusTapped: (() -> Void)?
    var onPlusTapped: (() -> Void)?

    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
}

//MARK: - Configure
extension CartProductCollectionViewCell {
    func configureWith(product: ProductResponseElement, discountedPrice: Int?, isSelected: Bool? = true) {
        innerImage.tintColor = (isSelected ?? true) ? .tabbarBackgroundColor : .clear
        loadProductImage(from: product.image)
        productName.text = product.title
        productCategory.text = product.category
        productSize.text = product.size
        updatePriceLabel(price: product.price, quantity: product.quantity)
        changePriceLabels(discountedPrice: discountedPrice)
        updateQuantityLabel(quantity: product.quantity)
        updateMinusImage(quantity: product.quantity)
    }
}

//MARK: - Setups
private extension CartProductCollectionViewCell {
    final func setups() {
        setupTexts()
        setupBackgrounds()
        setupButtonsUI()
        addTapGesture()
    }
    
    final func setupTexts() {
        productCountLabel.adjustsFontSizeToFitWidth = true
        productCountLabel.textColor = .white
    }
    
    final func setupBackgrounds() {
        backgroundOfImageView.backgroundColor = .clear
        backgroundOfImageView.layer.borderWidth = 1
        backgroundOfImageView.layer.borderColor = UIColor.lightDividerColor.cgColor
        backgroundOfImageView.layer.cornerRadius = 8
        
        
        productCountBackgroundView.backgroundColor = .tabbarBackgroundColor.withAlphaComponent(0.5)
        productCountBackgroundView.layer.cornerRadius = productCountBackgroundView.frame.width / 2
        
        minusPlusBackView.layer.cornerRadius = 8
        minusPlusBackView.layer.borderColor = UIColor.tabbarBackgroundColor.cgColor
        minusPlusBackView.layer.borderWidth = 1
    }
    
    final func setupButtonsUI() {
        minusButtonImage.tintColor = .tabbarBackgroundColor
        plusButtonImage.image = .plusImage
        plusButtonImage.tintColor = .tabbarBackgroundColor
        
        //TODO: bu buton hem sortda var hem burada var view ortaklaştırılacak
        topImageView.backgroundColor = .clear
        containerImage.image = .systemCircleImage
        containerImage.tintColor = .tabbarBackgroundColor
        outerImage.image = .systemCircleImage
        outerImage.tintColor = .white
        innerImage.image = .systemCircleImage
    }
    
    final func addTapGesture() {
        let selectionGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSelection))
        topImageView.addGestureRecognizer(selectionGesture)
        topImageView.isUserInteractionEnabled = true
        
        let minusGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMinus))
        minusButtonImage.addGestureRecognizer(minusGesture)
        minusButtonImage.isUserInteractionEnabled = true
        
        let plusGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPlus))
        plusButtonImage.addGestureRecognizer(plusGesture)
        plusButtonImage.isUserInteractionEnabled = true
    }
     
}

//MARK: - Helpers
private extension CartProductCollectionViewCell {
    final func changePriceLabels(discountedPrice: Int?) {
        guard let discountedPrice else {
            discountedPriceLabel.isHidden = true
            priceLabel.font = .boldSystemFont(ofSize: 24)
            priceLabel.textColor = .black
            if let text = priceLabel.text {
                priceLabel.attributedText = NSAttributedString(string: text)
            }
            return
        }
        
        discountedPriceLabel.isHidden = false
        priceLabel.font = .systemFont(ofSize: 18)
        priceLabel.textColor = .gray
        discountedPriceLabel.text = String(discountedPrice)
        guard let text = priceLabel.text else { return }
        let attributedText = NSAttributedString(string: text, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        priceLabel.attributedText = attributedText
    }
    
    final func updatePriceLabel(price: Double?, quantity: Int?) {
        guard let price,
              let quantity
        else {
            return priceLabel.text = "N/A"
        }
        let totalPrice = String(format: "%.2f", price * Double(quantity))
        priceLabel.text = "\(totalPrice) $"
    }
    
    final func loadProductImage(from urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else {
            return productImage.image = .noImage
        }
        productImage.loadImage(with: url, cornerRadius: 8, contentMode: .scaleAspectFit)
    }
    
    final func updateQuantityLabel(quantity: Int?) {
        guard let quantity else { return productCountLabel.text = "N/A" }
        productCountLabel.text = String(quantity)
    }
    
    final func updateMinusImage(quantity: Int?) {
        guard let quantity else { return minusButtonImage.image = .minusImage }
        minusButtonImage.image = quantity > 1 ? .minusImage : .trashImage
    }
}


//MARK: - Actions
private extension CartProductCollectionViewCell {
    @objc final func tappedSelection() {
        onSelectionTapped?()
    }
    
    @objc final func tappedMinus() {
        onMinusTapped?()
    }
    
    @objc final func tappedPlus() {
        onPlusTapped?()
    }
}
