//
//  CouponCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 16.08.2024.
//


//TODO: localizable
import UIKit

// MARK: - CouponCell
class CouponCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var couponTextField: UITextField!
    @IBOutlet private weak var applyLabelBackView: UIView!
    @IBOutlet private weak var applyButtonLabel: UILabel!
    @IBOutlet private weak var warningLabel: UILabel!
    
    // MARK: - Properties
    var onApplyTapped: ((_ couponText: String) -> Void)?
    var isDiscountCouponValid: ((Bool) -> Void)?

    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
}


//MARK: - CouponCell
extension CouponCell {
    func deleteCoupon() {
        warningLabel.isHidden = true
        couponTextField.text = ""
    }
}

//MARK: - Setups
private extension CouponCell {
    final func setups() {
        applyButtonLabel.text = "Uygula"
        applyButtonLabel.textColor = .black
        applyLabelBackView.backgroundColor = .clear
        applyLabelBackView.layer.borderColor = UIColor.lightDividerColor.cgColor
        applyLabelBackView.layer.borderWidth = 1
        warningLabel.isHidden = true
        
        addTapGesture()
    }
    
    final func setupTextField() {
        couponTextField.delegate = self
        couponTextField.layer.borderColor = UIColor.lightDividerColor.cgColor
        couponTextField.layer.borderWidth = 1.0
        couponTextField.layer.cornerRadius = 5.0
        couponTextField.backgroundColor = .white
        couponTextField.textColor = .black
        
        let placeholderColor = UIColor.lightGray
        couponTextField.attributedPlaceholder = NSAttributedString(
            string: "Kampanya Kodu",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        let customClearButton = UIButton(type: .custom)
        customClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        customClearButton.tintColor = .tabbarBackgroundColor
        customClearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)

        let containerViewofButton = UIView(frame: CGRect(x: 0, y: 0, width: customClearButton.frame.width, height: couponTextField.frame.height - 4))
        containerViewofButton.backgroundColor = .clear
        
        customClearButton.translatesAutoresizingMaskIntoConstraints = false
        containerViewofButton.addSubview(customClearButton)

        NSLayoutConstraint.activate([
            customClearButton.heightAnchor.constraint(equalTo: containerViewofButton.heightAnchor),
            customClearButton.trailingAnchor.constraint(equalTo: containerViewofButton.trailingAnchor, constant: -4),
            customClearButton.leadingAnchor.constraint(equalTo: containerViewofButton.leadingAnchor),
        ])
        
        couponTextField.rightView = containerViewofButton
        couponTextField.rightViewMode = .whileEditing
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
        setCoupons(isClearButtonTapped: false)
        onApplyTapped?(couponTextField.text ?? "")
    }
    
    final func setCoupons(isClearButtonTapped: Bool) {
        isDiscountCouponValid = { [weak self] isValid in
            guard let self else { return }
            warningLabel.isHidden = isClearButtonTapped
            warningLabel.text = isValid ? "Kupon Uygulandı" : "Kupon Geçerli Değil"
            applyButtonLabel.text = isValid ? "Uygulandı" : "Uygula"
            warningLabel.textColor = isValid ? .tabbarBackgroundColor : .red
          }
    }
    
    @objc final func clearTextField() {
        couponTextField.text = ""
        setCoupons(isClearButtonTapped: true)
        onApplyTapped?("")
    }
    
}

//MARK: - UITextFieldDelegate
extension CouponCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}
