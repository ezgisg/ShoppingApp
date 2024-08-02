//
//  CampaignCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import UIKit

class CampaignCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
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
        label.text = text
    }
    
    func setupUI() {
        label.textColor = .black
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
}

