//
//  ProductCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import AppManagers
import Combine
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
    private var cancellable: AnyCancellable?
    
    //MARK: - Life Cycles
    public override func awakeFromNib() {
        super.awakeFromNib()
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
        cancellable?.cancel()
        cancellable = CartManager.shared.cartItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: {  [weak self] cart in
                guard let self else { return }
                guard let product else { return }
                let isInCart = cart.contains { $0.productId == product.id }
                addCartImage.tintColor = isInCart ? .black : .lightGray
            })
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
    
    final func manageFavoriteImage() {
        guard let product else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(product: product)
        addFavoriteImage.tintColor = isFavorite ? .systemRed : .lightGray
    }
}
