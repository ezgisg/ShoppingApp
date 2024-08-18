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
    @IBOutlet weak var applyLabelBackView: UIView!
    @IBOutlet weak var applyButtonLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - Properties
    var onApplyTapped: ((_ couponText: String) -> Void)?
    var isDiscountCouponValid: ((Bool) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
        controlCoupon()
    }
    
    func deleteCoupon() {
        warningLabel.isHidden = true
        couponTextField.text = ""
    }

}

//MARK: - Setups
private extension CouponCell {
    final func setups() {
        couponTextField.layer.borderColor = UIColor.lightDividerColor.cgColor
        couponTextField.layer.borderWidth = 1.0
        couponTextField.layer.cornerRadius = 5.0
        couponTextField.backgroundColor = .clear
        couponTextField.textColor = .black
        let placeholderColor = UIColor.lightGray
        couponTextField.attributedPlaceholder = NSAttributedString(
            string: "Kampanya Kodu",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        applyButtonLabel.text = "Uygula"
        applyButtonLabel.textColor = .black
        applyLabelBackView.backgroundColor = .clear
        applyLabelBackView.layer.borderColor = UIColor.lightDividerColor.cgColor
        applyLabelBackView.layer.borderWidth = 1
        warningLabel.isHidden = true
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
        onApplyTapped?(couponTextField.text ?? "")
    }

    final func controlCoupon() {
        isDiscountCouponValid = { [weak self] isValid in
            guard let self else { return }
            warningLabel.isHidden = false
            warningLabel.text = isValid ? "Kupon Uygulandı" : "Kupon Geçerli Değil"
            warningLabel.textColor = isValid ? .tabbarBackgroundColor : .red
          }
    }
}
