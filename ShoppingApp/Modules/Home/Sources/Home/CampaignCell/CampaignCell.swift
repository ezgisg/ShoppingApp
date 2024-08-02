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

    func configureWith(image: UIImage, text: String) {
        imageView.image = image
        label.text = text
    }
    
    func setupUI() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
}
