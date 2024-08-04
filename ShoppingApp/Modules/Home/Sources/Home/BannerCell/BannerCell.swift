//
//  BannerCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configureWith(image: UIImage) {
        imageView.image = image

    }
    
    func configureWithImagePath(imagePath: String, cornerRadius: CGFloat = 0, text: String = "") {
        let url = URL(string: imagePath)
        if let url {
            imageView.loadImage(with: url, cornerRadius: cornerRadius)
        }
        label.text = text
    }
    
    func setupUI() {
        imageView.backgroundColor = .clear
        self.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = .clear
    }
    
}

