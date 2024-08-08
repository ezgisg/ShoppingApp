//
//  RegisterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import Base
import FirebaseAuth
import FirebaseFirestore
import UIKit
import TabBar

// MARK: - RegisterViewController
class RegisterViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var customInformationView: CustomInformationView!
    
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
    @IBOutlet private weak var passwordConditionWarningLabel: UILabel!
    @IBOutlet private weak var passwordWarningLabel: UILabel!
    
    // MARK: - Module Components
    private var viewModel = RegisterViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.delegate = self
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
        checkBoxView.configureWith(
            initialImage: .uncheck,
            secondImage: .check,
            textContent: L10nSignIn.PrivacyPolicy.longTitle.localized(),
            boldContent: L10nSignIn.PrivacyPolicy.title.localized(),
            isCheckBoxImageNeeded: false
        )
        secondCheckBoxView.configureWith(
            initialImage: .uncheck,
            secondImage: .check,
            textContent: L10nSignIn.MembershipAgreement.longTitle.localized(),
            boldContent: L10nSignIn.MembershipAgreement.title.localized(),
            isCheckBoxImageNeeded: true
        )
        
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
    }
    
    final func setupColor() {
        registerButton.backgroundColor = .lightButtonColor
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
        passwordConditionWarningLabel.textColor = .warningTextColor
        emailWarningLabel.textColor = .warningTextColor
        passwordWarningLabel.textColor = .warningTextColor
        
        nameTextField.textColor = .textColor
        surnameTextField.textColor = .textColor
        emailTextField.textColor = .textColor
        passwordTextField.textColor = .textColor
        confirmPasswordTextField.textColor = .textColor
    }
    
    final func setupInitialStatus() {
        nameLabel.isHidden = true
        surnameLabel.isHidden = true
        emailLabel.isHidden = true
        passwordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        emailWarningLabel.isHidden = true
        passwordConditionWarningLabel.isHidden = true
        passwordWarningLabel.isHidden = true
        customInformationView.isHidden = true
        registerButton.isEnabled = false
    }
    
    func setupDelegate() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    final func setup() {
        registerButton.layer.cornerRadius = 10
        setupText()
        setupColor()
        
        controlCheckStatus()
        setupKeyboardObservers(scrollView: scrollView)
        setupDelegate()
        setupInitialStatus()
        
        ///To change register button enabling status simultaneously
        /// Modification is made manually in other text fields so it works only these two
        [nameTextField, surnameTextField].forEach { textField in
            textField.addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
        }
    }
}

// MARK: - Actions
private extension RegisterViewController {
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard
            let name = nameTextField.text?.trimming,
            let surname = surnameTextField.text?.trimming,
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        view.endEditing(true)
//        showLoadingView()
        
        ///Creating user with firebase
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] authResult,
            error in
            guard let self else { return }
            hideLoadingView()
            if let error {
                showAlert(
                    title: L10nGeneric.error.localized(),
                    message: error.localizedDescription,
                    buttonTitle: L10nGeneric.ok.localized(),
                    completion: nil
                )
            } else if let uid = authResult?.user.uid {
                Task {  [weak self] in
                    guard let self else { return }
                    ///Recording user name&surname infos to firebase firestore
                    await viewModel.addUserInfosToFirestore(uid: uid, name: name, surname: surname)
                }
            } else {
                showAlert(
                    title: L10nGeneric.error.localized(),
                    message: L10nGeneric.unknownError.localized(),
                    buttonTitle: L10nGeneric.ok.localized(),
                    completion: nil
                )
            }
        }
    }
}

// MARK: - Control checkBox status
private extension RegisterViewController {
   
    final func controlCheckStatus() {
        secondCheckBoxView.onImageTapped = { [weak self] in
            guard let self else { return }
            viewModel.isSelectedMembershipAggrementCheckBox.toggle()
            ///To control enable-disable status for register button
            controlRegisterConditions()
        }
        
        checkBoxView.onTextTapped = { [weak self] in
            guard let self else { return }
            customInformationView.configureWith(
                message: L10nSignIn.PrivacyPolicy.description.localized(),
                messageTitle: L10nSignIn.PrivacyPolicy.title.localized()
            )
            customInformationView.isHidden = false
        }
        
        secondCheckBoxView.onTextTapped = { [weak self] in
            guard let self else { return }
            customInformationView.configureWith(
                message: L10nSignIn.MembershipAgreement.description.localized(),
                messageTitle: L10nSignIn.MembershipAgreement.title.localized()
            )
            customInformationView.isHidden = false
        }
    }
}

//MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    ///To control show-hide status of title label and placeholder
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
    
    ///To control show-hide status of title label and placeholder
    func textFieldDidEndEditing(_ textField: UITextField) {
        controlRegisterConditions()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            surnameTextField.becomeFirstResponder()
        case surnameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField,
             surnameTextField:
            ///To check whether the password contains name/surname when the name or surname changes
            guard let password = passwordTextField.text else { return }
            passwordConditionWarningLabel.isHidden = isPasswordValid(password: password)
            
        case emailTextField:
            ///To check whether email complies with the format
            guard
                let text = emailTextField.text,
                !text.isEmpty,
                !text.isValidEmail
            else {
                emailWarningLabel.isHidden = true
                return
            }
            emailWarningLabel.isHidden = false
            
        case passwordTextField, confirmPasswordTextField:
            ///To check whether the  current password is suitable for password rules
            guard let password = passwordTextField.text else { return }
            passwordConditionWarningLabel.isHidden = isPasswordValid(password: password)
            ///To check passwords are match or not
            guard
                let passwordConfirm = confirmPasswordTextField.text,
                !password.isEmpty, !passwordConfirm.isEmpty,
                password != passwordConfirm
            else {
                passwordWarningLabel.isHidden = true
                return
            }
                passwordWarningLabel.isHidden = false
            break
            
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        ///To control spaces to allow just between words
        case nameTextField, surnameTextField:
            return textField.isOnlyLettersWithValidSpaces(
                range: range,
                string: string,
                maxLength: 42
            )
        ///To remove spaces
        default:
            if let textRange = Range(range, in: textField.text ?? "") {
                let updatedText = textField.text?.replacingCharacters(
                    in: textRange,
                    with: string
                )
                textField.text = updatedText?.withoutSpaces
                ///To change register button enabling status simultaneously
                ///Can not use editingChanged because modification is made manually
                controlRegisterConditions()
            }
            return false
        }
    }

    /// Triggered on the search text value changes.
    @objc final func textFieldDidChange(_ textField: UITextField) {
        controlRegisterConditions()
    }
}

//MARK: Helpers
private extension RegisterViewController {
    ///To show label when textfield is active
    final func showLabel(label: UILabel, textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            label.isHidden = false
            textField.placeholder = nil
        }
    }
    ///To hide label when textfield is not active
    final func hideLabel(label: UILabel, textField: UITextField, placeholderText: String) {
        label.isHidden = true
        textField.placeholder = placeholderText
    }
    
    ///To control whether password is valid or not and set the password control message for the condition
    final func isPasswordValid(password: String) -> Bool {
        let message = viewModel.determinePasswordValidationMessage(password: password, name: nameTextField.text, surname: surnameTextField.text)
        guard let message else { return true }
        passwordConditionWarningLabel.text = message
        return false
    }
    
    ///To control register enabling status,
    final func controlRegisterConditions() {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let passwordConfirm = confirmPasswordTextField.text,
              !name.isEmpty,
              !surname.isEmpty,
              password == passwordConfirm,
              email.isValidEmail,
              isPasswordValid(password: password),
              viewModel.isSelectedMembershipAggrementCheckBox
        else {
            registerButton.backgroundColor = .lightButtonColor
            return registerButton.isEnabled = false
        }
        registerButton.backgroundColor = .buttonColor
        registerButton.isEnabled = true
    }
}


//MARK: RegisterViewModelDelegate
extension RegisterViewController: RegisterViewModelDelegate {
    func didAddUserInfos() {
        // TODO: email doğrulandı mı kontrolü yapılacak, doğrulanmadıysa tabbar a geçilmeyecek
        let viewController = TabBarController()
        pushWithTransition(viewController)
    }
    
    func didFailToAddUserInfos(error: Error) {
        //TODO: ok'a basıldığında başarılı olduğunda nereye gidiliyorsa oraya gidelim
        showAlert(
            title: L10nGeneric.error.localized(),
            message: error.localizedDescription,
            buttonTitle: L10nGeneric.ok.localized(),
            completion: nil
        )
    }
}
