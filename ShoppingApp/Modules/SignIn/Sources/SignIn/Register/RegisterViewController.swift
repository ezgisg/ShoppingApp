//
//  RegisterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import Base
import UIKit

// MARK: - RegisterViewController
class RegisterViewController: BaseViewController {

   
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!

    @IBOutlet private weak var leftBackgroundCircle: UIImageView!
    @IBOutlet private weak var leftMainCircle: UIImageView!
    @IBOutlet private weak var rightMainCircle: UIImageView!
    @IBOutlet private weak var rightBackgroundCircle: UIImageView!

    @IBOutlet private weak var registerMessage: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var surnameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var confirmPasswordLabel: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet private weak var checkBoxView: CheckBoxView!
    @IBOutlet private weak var secondCheckBoxView: CheckBoxView!
    @IBOutlet private weak var registerButton: UIButton!

    @IBOutlet private weak var emailWarningLabel: UILabel!
    @IBOutlet private weak var passwordWarningLabel: UILabel!
    
    // MARK: - Module Components
    private var viewModel = RegisterViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        controlCheckStatus()
        setupKeyboardObservers(scrollView: scrollView)
        setupDelegate()
        
    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups
private extension RegisterViewController {
    final func setupText() {
        checkBoxView.configureWith(initialImage: .uncheck, secondImage: .check, textContent: L10nSignIn.PrivacyPolicy.longTitle.localized(), boldContent: L10nSignIn.PrivacyPolicy.title.localized(), isCheckBoxImageNeeded: false)
        secondCheckBoxView.configureWith(initialImage: .uncheck, secondImage: .check, textContent: L10nSignIn.MembershipAgreement.longTitle.localized(), boldContent: L10nSignIn.MembershipAgreement.title.localized(), isCheckBoxImageNeeded: true)
        registerButton.setTitle(L10nSignIn.register.localized(), for: .normal)
        registerMessage.text = L10nSignIn.registerMessage.localized()
        
        nameLabel.text = L10nGeneric.name.localized()
        surnameLabel.text = L10nGeneric.surname.localized()
        emailLabel.text = L10nGeneric.email.localized()
        passwordLabel.text = L10nGeneric.password.localized()
        confirmPasswordLabel.text = L10nGeneric.passwordConfirm.localized()
        emailWarningLabel.text = L10nGeneric.emailWarning.localized()
        passwordWarningLabel.text = L10nSignIn.passwordWarning.localized()
        
        nameTextField.placeholder = L10nGeneric.name.localized()
        surnameTextField.placeholder = L10nGeneric.surname.localized()
        emailTextField.placeholder = L10nGeneric.email.localized()
        passwordTextField.placeholder = L10nGeneric.password.localized()
        confirmPasswordTextField.placeholder = L10nGeneric.passwordConfirm.localized()
        
        nameLabel.isHidden = true
        surnameLabel.isHidden = true
        emailLabel.isHidden = true
        passwordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        emailWarningLabel.isHidden = true
        passwordWarningLabel.isHidden = true
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
        registerButton.layer.cornerRadius = 10
        setupText()
        setupColor()
    }
}

// MARK: - Check conditions
private extension RegisterViewController {
    
    @IBAction func registerButtonClicked(_ sender: Any) {
    }
    
    final func controlCheckStatus() {
        secondCheckBoxView.onImageTapped = { [weak self] in
            guard let self else { return }
            viewModel.isSelectedMembershipAggrementCheckBox.toggle()
        }
        checkBoxView.onTextTapped = { [weak self] in
            guard let self else { return }
            //TODO: Metin alanı açılacak
        }
        secondCheckBoxView.onTextTapped = { [weak self] in
            guard let self else { return }
            //TODO: Metin alanı açılacak
        }
    }
}


//MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            showLabel(label: nameLabel, textField: nameTextField)
        case surnameTextField:
            showLabel(label: surnameLabel, textField: surnameTextField)
        case emailTextField:
            showLabel(label: emailLabel, textField: emailTextField)
        case passwordTextField:
            showLabel(label: passwordLabel, textField: passwordTextField)
        case confirmPasswordTextField:
            showLabel(label: confirmPasswordLabel, textField: confirmPasswordTextField)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            hideLabel(label: nameLabel, textField: nameTextField, placeholderText: L10nGeneric.name.localized())
        case surnameTextField:
            hideLabel(label: surnameLabel, textField: surnameTextField, placeholderText: L10nGeneric.surname.localized())
        case emailTextField:
            hideLabel(label: emailLabel, textField: emailTextField, placeholderText: L10nGeneric.email.localized())
        case passwordTextField:
            hideLabel(label: passwordLabel, textField: passwordTextField, placeholderText: L10nGeneric.password.localized())
        case confirmPasswordTextField:
            hideLabel(label: confirmPasswordLabel, textField: confirmPasswordTextField, placeholderText: L10nGeneric.passwordConfirm.localized())
        default:
            break
        }
    }
    
    func setupDelegate() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
}

//MARK: Helpers
private extension RegisterViewController {
    final func showLabel(label: UILabel, textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            label.isHidden = false
            textField.placeholder = nil
        }
    }
    final func hideLabel(label: UILabel, textField: UITextField, placeholderText: String) {
        label.isHidden = true
        textField.placeholder = placeholderText
    }
}
