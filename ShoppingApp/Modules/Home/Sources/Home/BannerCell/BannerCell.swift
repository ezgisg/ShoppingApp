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
        // Initialization code
    }

    func configureWith(image: UIImage) {
        imageView.image = image
    }
    
    func setupUI() {
        
    }
    
}
