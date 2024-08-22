//
//  PaymentCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.08.2024.
//

import UIKit

class PaymentCell: UICollectionViewCell {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private final func setup() {
        image1.image = .browseImage
        image2.image = .browseImage
        image3.image = .browseImage
        label1.text = "Ödeme Tipi"
        label2.text = "Ödeme Tipi"
        label3.text = "Ödeme Tipi"
        label1.textColor = .gray
        label2.textColor = .gray
        label3.textColor = .gray
        label1.font = .systemFont(ofSize: 14, weight: .thin)
        label2.font = .systemFont(ofSize: 14, weight: .thin)
        label3.font = .systemFont(ofSize: 14, weight: .thin)
    }
    
}
