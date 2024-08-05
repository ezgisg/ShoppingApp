//
//  CategoryBannerCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import UIKit

class CategoryBannerCell: UICollectionViewCell {

    @IBOutlet weak var outsideContainerView: UIView!
    @IBOutlet weak var insideContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    func configureWith(imagePath: String) {
        let url = URL(string: imagePath)
        if let url {
            imageView.loadImage(with: url)
        }
    }
    
    func setupUI() {
        imageView.layer.cornerRadius = 4
        insideContainerView.backgroundColor = .middleButtonColor
        outsideContainerView.backgroundColor = .tabbarBackgroundColor
    }
    
}

