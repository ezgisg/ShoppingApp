//
//  PaymentCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.08.2024.
//

import AppResources
import UIKit

//MARK: - PaymentCell
class PaymentCell: UICollectionViewCell {

    @IBOutlet private weak var image1: UIImageView!
    @IBOutlet private weak var label1: UILabel!
    @IBOutlet private weak var image2: UIImageView!
    @IBOutlet private weak var label2: UILabel!
    @IBOutlet private weak var image3: UIImageView!
    @IBOutlet private weak var label3: UILabel!
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    //MARK: - Setup
    private final func setup() {
        image1.image = .cash
        image2.image = .checkoutImage
        image3.image = .masterpass
        
        label1.text = L10nGeneric.paymentOptions.cashAtDelivery.localized()
        label2.text = L10nGeneric.paymentOptions.creditBankCard.localized()
        label3.text = L10nGeneric.paymentOptions.masterpass.localized()
        
        setupTextAndFont(label: label1)
        setupTextAndFont(label: label2)
        setupTextAndFont(label: label3)
        
        func setupTextAndFont(label: UILabel) {
            label.textColor = .gray
            label.font = .systemFont(ofSize: 14, weight: .thin)
        }
    }
}
