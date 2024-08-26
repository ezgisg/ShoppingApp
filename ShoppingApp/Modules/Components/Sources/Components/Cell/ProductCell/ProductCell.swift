//
//  ProductCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import AppManagers
import UIKit

//MARK: - ProductCell
public class ProductCell: UICollectionViewCell {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addFavoriteImage: UIImageView!
    @IBOutlet weak var addCartImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    
    // MARK: - Properties
    public var onFavoriteTapped: (() -> Void)?
    public var onCartTapped: (() -> Void)?
    
    private var product: ProductResponseElement?
    
    //MARK: - Life Cycles
    public override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        setupUI()
        setupGestureRecognizers()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        ratingView.setRating(0)
    }
    
    private func setupUI() {
        imageContainerView.layer.cornerRadius = 2
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        
        imageContainerView.backgroundColor = .white
        mainContainerView.backgroundColor = .white
        stackView.backgroundColor = .white
        ratingView.backgroundColor = .white
        
        productNameLabel.textColor = .darkGray
        categoryNameLabel.textColor = .darkGray
        ratingCountLabel.textColor = .darkGray
        priceLabel.textColor = .darkGray
    }
    
}

//MARK: - ProductCell Configure
extension ProductCell {
    public func configure(withId id: Int?, withRating rating: Double?, ratingCount: Int?, categoryName: String?, productName: String?, price: Double?, imagePath: String?) {
        product = ProductResponseElement(id: id, title: productName, price: price, category: categoryName, image: imagePath)
        if let rating,
           let ratingCount {
            ratingStack.isHidden = false
            ratingView.setRating(rating)
            ratingCountLabel.text = "(\(String(ratingCount)))"
        } else {
            ratingStack.isHidden = true
        }
        categoryNameLabel.text = categoryName ?? ""
        productNameLabel.text = productName ?? ""
        priceLabel.text = price != nil ? "\(String(price!)) $" : "N/A"

        guard let urlString = imagePath, let url = URL(string: urlString)
        else { return productImage.image = .noImage }
        productImage.loadImage(with: url, contentMode: .scaleAspectFit)
        manageFavoriteImage()
        manageCartImage()
    }
}

//MARK: ProductCell
private extension ProductCell {
    func setupGestureRecognizers() {
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavorite))
        addFavoriteImage.isUserInteractionEnabled = true
        addFavoriteImage.addGestureRecognizer(favoriteTapGesture)

        let cartTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCart))
        addCartImage.isUserInteractionEnabled = true
        addCartImage.addGestureRecognizer(cartTapGesture)
    }
    
    @objc private func didTapFavorite() {
        onFavoriteTapped?()
        manageFavoriteImage()
    }
       
    @objc private func didTapCart() {
        onCartTapped?()
    }
    
    @objc final func cartUpdated() {
        manageCartImage()
    }
    
    final func manageFavoriteImage() {
        guard let product else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(product: product)
        addFavoriteImage.tintColor = isFavorite ? .systemRed : .lightGray
    }
    
    final func manageCartImage() {
        guard let product else { return }
        let isInCart = CartManager.shared.cartItems.contains { $0.productId == product.id }
        addCartImage.tintColor = isInCart ? .black : .lightGray
    }
}
