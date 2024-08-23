//
//  ProductDetailCell.swift
//
//
//  Created by Ezgi Sümer Günaydın on 21.08.2024.
//

import AppManagers
import AppResources
import Components
import UIKit


//MARK: - ProductDetailCell
class ProductDetailCell: UICollectionViewCell, NibLoadable {
    static var module = Bundle.module
    
    //MARK: - Outlets
    @IBOutlet private weak var dismissImage: UIImageView!
    @IBOutlet private weak var addFavoriteImage: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var ratingView: StarRatingView!
    @IBOutlet private weak var ratingCountLabel: UILabel!
     
    // MARK: - Properties
    public var onFavoriteTapped: (() -> Void)?
    public var onDismissTapped: (() -> Void)?
    
    //MARK: - Private Variables
    private var product: ProductResponseElement?
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//MARK: - Configuration
extension ProductDetailCell {
    final func configureWith(product: ProductResponseElement?) {
        self.product = product
        setPrice(price: product?.price)
        setProductName(name: product?.title)
        setCategory(category: product?.category)
        setRating(ratingCount: product?.rating?.count, rating: product?.rating?.rate)
        loadImage(imagePath: product?.image)
        manageFavoriteImage()
    }
}

//MARK: - Actions
private extension ProductDetailCell {
    @objc final func didTapFavorite() {
        onFavoriteTapped?()
        manageFavoriteImage()
    }
    
    @objc final func didTapDismiss() {
        onDismissTapped?()
    }
}

//MARK: - Setups
private extension ProductDetailCell {
    final func setups() {
        setupGestureRecognizers()
    }
    
    final func setupGestureRecognizers() {
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavorite))
        addFavoriteImage.isUserInteractionEnabled = true
        addFavoriteImage.addGestureRecognizer(favoriteTapGesture)
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        dismissImage.isUserInteractionEnabled = true
        dismissImage.addGestureRecognizer(dismissTapGesture)
        
    }
}

//MARK: - Helpers
private extension ProductDetailCell {
    final func setPrice(price: Double?) {
        guard let price else { return priceLabel.text = "N/A" }
        let formattedPrice = String(format: "%.2f", price)
        priceLabel.text = "\(formattedPrice) $"
    }
    
    final func setCategory(category: String?) {
        guard let category else { return categoryNameLabel.text = "N/A" }
        categoryNameLabel.text = category
    }
    
    final func setProductName(name: String?) {
        guard let name else { return productNameLabel.text = "N/A" }
        productNameLabel.text = name
    }
    
    final func setRating(ratingCount: Int?, rating: Double?) {
        guard let rating,
              let ratingCount else { return ratingCountLabel.text = "N/A" }
        ratingCountLabel.text = "\(ratingCount) Değerlendirme"
        ratingView.setRating(Double(rating))
    }
    
    final func loadImage(imagePath: String?) {
        guard let imagePath,
              let url = URL(string: imagePath)
        else { return imageView.image = .noImage }
        imageView.loadImage(with: url, cornerRadius: 0, contentMode: .scaleAspectFit)
    }
    
    final func manageFavoriteImage() {
        guard let product else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(product: product)
        addFavoriteImage.tintColor = isFavorite ? .systemRed : .lightGray
    }
}
