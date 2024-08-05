//
//  CategoryCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import AppResources
import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var decorationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    
    func configureWith(imagePath: String, text: String) {
        let url = URL(string: imagePath)
        if let url {
            imageView.loadImage(with: url, cornerRadius: imageView.frame.width / 2)
        }
        categoryName.text = text
    }
    
    func setupUI() {
        categoryName.textColor = .tabbarBackgroundColor
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.tabbarBackgroundColor.cgColor
    }
}
