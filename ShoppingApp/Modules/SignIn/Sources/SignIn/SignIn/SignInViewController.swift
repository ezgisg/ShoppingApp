//
//  SignInViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.07.2024.
//

import AppResources
import Base
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UIKit

//MARK: - SignInViewController
public class SignInViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
    @IBOutlet weak var loginMainImage: UIImageView!
    @IBOutlet weak var passwordHideShowImage: UIImageView!
    
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingMessageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailWarningLabel: UILabel!
    
    @IBOutlet weak var googleContainterView: UIView!
    //MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleAuth()
        setupUI()
        setupKeyboardObservers()
    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Setups Sign In
extension SignInViewController {
    
    ///Google sign-in
    func setupGoogleAuth() {
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(googleSignInTapped))
        signInWithGoogle.addGestureRecognizer(tapGesture)
    }
    
    @objc func googleSignInTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil,
                  let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard let _ = result, nil == nil else { return }
            }
          
        }
    }
    
    //E-mail sign-in
    @IBAction func signInWithEmail(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            //TODO: Alert
            return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let self else { return }
            guard let error else {
                //TODO: Page e yönlendirme
                return
            }
            //TODO: Alert
        }
    }
    
}


//MARK: - Setup UI
private extension SignInViewController {
    func setupUI() {
        setupTexts()
        setupImages()
        setupPasswordToggle()
        setupColors()
    
    }
    
    func setupTexts() {
        onboardingTitleLabel.text = L10nSignIn.SignInOnboarding.title.localized()
        onboardingMessageLabel.text = L10nSignIn.SignInOnboarding.message.localized()
        emailLabel.text = ""
        emailTextField.placeholder = L10nSignIn.email.localized()
        emailWarningLabel.text = ""
        passwordLabel.text = ""
        passwordTextField.placeholder = L10nSignIn.password.localized()
        forgetPasswordLabel.text = L10nSignIn.forgetPassword.localized()
        haveAccountLabel.text = L10nSignIn.haveAccount.localized()
        registerLabel.text = L10nSignIn.register.localized()
        signInButton.setTitle(L10nSignIn.signIn.localized(), for: .normal)
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func setupImages() {
        loginMainImage.image = .loginImage
        passwordHideShowImage.image = .passwordShowImage
    }
    
    func setupPasswordToggle() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
            passwordHideShowImage.isUserInteractionEnabled = true
            passwordHideShowImage.addGestureRecognizer(tapGesture)
        }
        
        @objc func togglePasswordVisibility() {
            passwordTextField.isSecureTextEntry.toggle()
            passwordHideShowImage.image = passwordTextField.isSecureTextEntry ? .passwordShowImage : .passwordHideImage
        }
    
    func setupColors() {
        googleContainterView.backgroundColor = .buttonColor
        googleContainterView.layer.cornerRadius = 5
        onboardingTitleLabel.textColor = .textColor
        onboardingMessageLabel.textColor = .textColor
        emailLabel.textColor = .lightTextColor
        emailTextField.textColor = .textColor
        emailWarningLabel.textColor = .textColor
        passwordLabel.textColor = .lightTextColor
        passwordTextField.textColor = .textColor
        forgetPasswordLabel.textColor = .textColor
        signInButton.backgroundColor = .buttonColor
        signInButton.setTitleColor(.buttonTextColor, for: .normal)
        signInButton.layer.cornerRadius = 5
        haveAccountLabel.textColor = .lightTextColor
        registerLabel.textColor = .textColor
        view.backgroundColor = .backgroundColor
    }
}


extension SignInViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = L10nSignIn.email.localized()
            emailTextField.placeholder = nil
        case passwordTextField:
            passwordLabel.text = L10nSignIn.password.localized()
            passwordTextField.placeholder = nil
        default:
            break
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = nil
            emailTextField.placeholder = L10nSignIn.email.localized()
        case passwordTextField:
            passwordLabel.text = nil
            passwordTextField.placeholder = L10nSignIn.password.localized()
        default:
            break
        }
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == emailTextField,
              let text = emailTextField.text,
              !text.isEmpty,
              !isValidEmail(text)
        else {
            emailWarningLabel.text = ""
            return }
            emailWarningLabel.text = L10nSignIn.emailWarning.localized()
    }
    
}

private extension SignInViewController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
