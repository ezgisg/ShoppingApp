//
//  ProductDetailCell.swift
//
//
//  Created by Ezgi Sümer Günaydın on 21.08.2024.
//

import AppResources
import Components
import UIKit

class ProductDetailCell: UICollectionViewCell, NibLoadable {
    static var module = Bundle.module
    
    
    @IBOutlet weak var dismissImage: UIImageView!
    @IBOutlet weak var addFavoriteImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        ratingView.setRating(0)
    }
    
    final func configureWith(product: ProductResponseElement?) {
        setPrice(price: product?.price)
        setProductName(name: product?.title)
        setCategory(category: product?.category)
        setRating(rating: product?.rating?.count)
    }
    
}

private extension ProductDetailCell {
    final func setups() {
        setupTexts()
        setupColors()
    }
    
    final func setupTexts() {
        
    }
    
    final func setupColors() {
        
    }
}

//MARK: - Helpers
private extension ProductDetailCell {
    final func setPrice(price: Double?) {
        guard let price else { return priceLabel.text = "N/A" }
        priceLabel.text = String(format: "%.2f", price)
    }
    
    final func setCategory(category: String?) {
        guard let category else { return categoryNameLabel.text = "N/A" }
        categoryNameLabel.text = category
    }
    
    final func setProductName(name: String?) {
        guard let name else { return productNameLabel.text = "N/A" }
        productNameLabel.text = name
    }
    
    final func setRating(rating: Int?) {
        guard let rating else { return ratingCountLabel.text = "N/A" }
        ratingCountLabel.text = "\(rating) Değerlendirme"
    }
}
