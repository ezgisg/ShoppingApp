//
//  BannerCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configureWith(image: UIImage) {
        imageView.image = image

    }
    
    func setupUI() {
        imageView.backgroundColor = .clear
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        self.backgroundColor = .clear
    }
    
}
