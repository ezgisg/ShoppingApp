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
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet private weak var applyLabelBackView: UIView!
    @IBOutlet private weak var applyButtonLabel: UILabel!
    @IBOutlet private weak var warningLabel: UILabel!
    
    // MARK: - Properties
    var onApplyTapped: ((_ isApplied: Bool) -> Void)?
    var couponTextChange: ((String) -> Void)?

    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    // MARK: - Configure
    final func configureWith(couponStatus: CouponStatus) {
        couponTextField.text = couponStatus.text
        warningLabel.isHidden = !couponStatus.isApplied
        warningLabel.text = couponStatus.isValid ? "Kupon Uygulandı" : "Kupon Geçerli Değil"
        applyButtonLabel.text = couponStatus.isValid ? "Uygulandı" : "Uygula"
        warningLabel.textColor = couponStatus.isValid ? .tabbarBackgroundColor : .red
    }
}

//MARK: - Setups
private extension CouponCell {
    final func setups() {
        applyButtonLabel.textColor = .black
        applyLabelBackView.backgroundColor = .clear
        applyLabelBackView.layer.borderColor = UIColor.lightDividerColor.cgColor
        applyLabelBackView.layer.borderWidth = 1
    
        setupTextField()
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
        onApplyTapped?(true)
    }
    
    @objc final func clearTextField() {
        onApplyTapped?(false)
    }
}

//MARK: - UITextFieldDelegate
extension CouponCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let text = updatedText.count <= 10 ? updatedText : currentText
        couponTextChange?(text)
        return updatedText.count <= 10
    }
}
