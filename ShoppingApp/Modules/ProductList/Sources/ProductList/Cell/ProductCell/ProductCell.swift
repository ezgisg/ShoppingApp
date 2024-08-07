//
//  ProductCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import UIKit

//MARK: - ProductCell
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
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
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
        //TODO: Sepete veya favorilere eklenip eklenmemesine göre farklı renkler alacak
        addFavoriteImage.tintColor = .lightGray
        addCartImage.tintColor = .lightGray
    }
}

//MARK: - ProductCell Configure
extension ProductCell {
    func configure(withRating rating: Double?, ratingCount: Int?, categoryName: String?, productName: String?, price: Double?, imagePath: String?) {
        ratingView.setRating(rating ?? 0)
        ratingCountLabel.text = "(\(String(ratingCount ?? 0)))"
        categoryNameLabel.text = categoryName ?? ""
        productNameLabel.text = productName ?? ""
        priceLabel.text = price != nil ? "\(String(price!)) $" : "N/A"

        guard let urlString = imagePath, let url = URL(string: urlString)
        else { return productImage.image = .noImage }
        productImage.loadImage(with: url, contentMode: .scaleAspectFit)
    }
}
