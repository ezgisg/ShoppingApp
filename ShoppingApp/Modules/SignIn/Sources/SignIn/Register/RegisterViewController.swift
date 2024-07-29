//
//  RegisterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var registerMessage: UILabel!
    
    @IBOutlet weak var leftBackgroundCircle: UIImageView!
    @IBOutlet weak var leftMainCircle: UIImageView!
    @IBOutlet weak var rightMainCircle: UIImageView!
    @IBOutlet weak var rightBackgroundCircle: UIImageView!
    
    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet weak var secondCheckBoxView: CheckBoxView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    

    
    private var isSelectedMembershipAggrementCheckBox: Bool = false {
        didSet {
            print("Membership Agreement CheckBox is selected: \(isSelectedMembershipAggrementCheckBox)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        secondCheckBoxView.onImageTapped = { [weak self] in
            guard let self else { return }
            isSelectedMembershipAggrementCheckBox.toggle()
        }

    }



    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
    }
    

}


private extension RegisterViewController {
    final func setupText() {
        checkBoxView.configureWith(initialImage: .uncheck, secondImage: .check, textContent: L10nSignIn.PrivacyPolicy.longTitle.localized(), boldContent: L10nSignIn.PrivacyPolicy.title.localized(), isCheckBoxImageNeeded: false)
        secondCheckBoxView.configureWith(initialImage: .uncheck, secondImage: .check, textContent: L10nSignIn.MembershipAgreement.longTitle.localized(), boldContent: L10nSignIn.MembershipAgreement.title.localized(), isCheckBoxImageNeeded: true)
        registerButton.setTitle(L10nSignIn.register.localized(), for: .normal)
        registerMessage.text = L10nSignIn.registerMessage.localized()
        
    }
    
    final func setupColor() {
        registerButton.backgroundColor = .buttonColor
        registerButton.setTitleColor(.buttonTextColor, for: .normal)
        
        containerView.backgroundColor = .backgroundColor
        
        rightMainCircle.tintColor = .buttonColor
        rightBackgroundCircle.tintColor = .buttonColor
        rightBackgroundCircle.layer.opacity = 0.5
        leftMainCircle.tintColor = .middleButtonColor
        leftBackgroundCircle.tintColor = .middleButtonColor
        leftBackgroundCircle.layer.opacity = 0.5
        
        registerMessage.textColor = .textColor
        nameLabel.textColor = .textColor
        surnameLabel.textColor = .textColor
        emailLabel.textColor = .textColor
        passwordLabel.textColor = .textColor
        confirmPasswordLabel.textColor = .textColor
        emailWarningLabel.textColor = .warningTextColor
        passwordWarningLabel.textColor = .warningTextColor
        
    }
    
    final func setupUI() {
        setupText()
        setupColor()
        
        registerButton.layer.cornerRadius = 10

    }
    
      
}



