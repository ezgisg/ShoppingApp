//
//  CouponCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 16.08.2024.
//


//TODO: localizable
import UIKit

class CouponCell: UICollectionViewCell {

    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var applyLabelBackView: UIView!
    @IBOutlet weak var applyButtonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }

}

//MARK: - Setups
private extension CouponCell {
    final func setups() {
        couponTextField.placeholder = "Kampanya Kodu"
        applyButtonLabel.text = "Uygula"
        textFieldBackView.backgroundColor = .lightDividerColor
        applyLabelBackView.backgroundColor = .clear
        applyLabelBackView.layer.borderColor = UIColor.lightDividerColor.cgColor
        applyLabelBackView.layer.borderWidth = 1

        addTapGesture()
        
    }
    
    final func addTapGesture() {
        let applyGesture = UITapGestureRecognizer(target: self, action: #selector(tappedApply))
        applyButtonLabel.addGestureRecognizer(applyGesture)
        applyButtonLabel.isUserInteractionEnabled = true
    }
}

//MARK: - Actions
private extension CouponCell {
    @objc final func tappedApply() {
   
    }
}
