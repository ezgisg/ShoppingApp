//
//  ProductCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import UIKit

class ProductCell: UICollectionViewCell {

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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ratingView.setRating(0)
    }
    
    func configure(withRating rating: Double?, ratingCount: Int?, categoryName: String?, productName: String?, price: Double?, imagePath: String?) {
        ratingView.setRating(rating ?? 0)
        ratingCountLabel.text = "(\(String(ratingCount ?? 0)))"
        categoryNameLabel.text = categoryName ?? ""
        productNameLabel.text = productName ?? ""
        if let price {
            priceLabel.text = "\(String(price)) $"
        } else {
            priceLabel.text = "N/A"
        }
        let url = URL(string: imagePath ?? "")
        if let url {
            productImage.loadImage(with: url, contentMode: .scaleAspectFit)
        }

      }
    
    private func setupUI() {
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        imageContainerView.layer.cornerRadius = 2
        imageContainerView.backgroundColor = .white
        mainContainerView.backgroundColor = .white
        stackView.backgroundColor = .white
        ratingView.backgroundColor = .white
        
        productNameLabel.textColor = .darkGray
        categoryNameLabel.textColor = .darkGray
        ratingCountLabel.textColor = .darkGray
        priceLabel.textColor = .darkGray
        
        addFavoriteImage.tintColor = .lightGray
        addCartImage.tintColor = .lightGray
        
        
    }
    
}
