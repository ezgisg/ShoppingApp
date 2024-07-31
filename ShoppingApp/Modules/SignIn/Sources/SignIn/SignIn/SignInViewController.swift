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
import TabBar

//TODO: error alertleri, şifremi unuttum.., kullanıcıyı login ettikten sonra hatırlama, register ....

//MARK: - SignInViewController
public class SignInViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var googleContainterView: UIView!
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
    
    //TODO: Gerek olmazsa kaldırılacak
    //MARK: Module Components
    var viewModel = SignInViewModel()
    
    //MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleAuth()
        setupUI()
        setupKeyboardObservers()
        
        resetPasswordSetup()
        setupRegister()
 
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
                guard let error else { 
                    let tabBarVC = TabBarController()
                    self.navigationController?.setViewControllers([tabBarVC], animated: false)
                    print("giriş yapıldı")
                    return }
                //TODO: Alert
                print("giriş yapılamadı")
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
                let tabBarVC = TabBarController()
                navigationController?.setViewControllers([tabBarVC], animated: false)
                print("giriş yapıldı")
                
             //TODO: Doğrulama maili ve password reset mailleri yerel dilde gönderilecek
                //TODO: email doğrulama deneme için buraya koyuldu, doğrulamadan içeri alınmayacak şekilde düzenleme yapılacak
                if Auth.auth().currentUser != nil {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                     print("doğrulama maili gönderildi")
                    }
                } else {
                  // No user is signed in.
                  // ...
                }
                
                return
            }
            //TODO: Alert
            print("giriş yapılamadı")
        }
    }
    
    func resetPasswordSetup() {
        forgetPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(forgetPasswordTapped))
        forgetPasswordLabel.addGestureRecognizer(tapGesture)
    }
    
    //TODO: forgetpassword için yeni bir sayfaya yönlendirme yapılacak
    @objc func forgetPasswordTapped() {
        let email = "ezgisumer-93"
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                print("**** error: ",error.localizedDescription)
            } else {
                print("**** mail yollandı")
            }
        }
    }
    
    // TODO: checkemailverification
    func checkEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.reload { error in
                if let error = error {
                    print("Kullanıcı bilgileri güncellenemedi: \(error.localizedDescription)")
                } else {
                    if user.isEmailVerified {
                      //ana ekrana yönlendirelim
                    } else {
                        // alert çünkü email verify değil
                    }
                }
            }
        } else {
            // giriş yok sign in sayfasına yönlendirelim
        }
    }
    
    func setupRegister() {
        registerLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(registerTapped))
        registerLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func registerTapped() {
        let viewController = RegisterViewController()
        pushWithTransition(viewController)
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
        emailLabel.text = L10nGeneric.email.localized()
        emailTextField.placeholder = L10nGeneric.email.localized()
        emailWarningLabel.text = ""
        passwordLabel.text = L10nGeneric.password.localized()
        passwordTextField.placeholder = L10nGeneric.password.localized()
        forgetPasswordLabel.text = L10nSignIn.forgetPassword.localized()
        haveAccountLabel.text = L10nSignIn.haveAccount.localized()
        registerLabel.text = L10nSignIn.register.localized()
        signInButton.setTitle(L10nSignIn.signIn.localized(), for: .normal)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.enablesReturnKeyAutomatically = true
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func setupImages() {
        loginMainImage.image = .loginImage
        passwordHideShowImage.image = .passwordShowImage
        
        passwordLabel.isHidden = true
        emailLabel.isHidden = true
    }
    
    func setupPasswordToggle() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        passwordHideShowImage.isUserInteractionEnabled = true
        passwordHideShowImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        passwordHideShowImage.image = passwordTextField.isSecureTextEntry ? .passwordHideImage : .passwordShowImage
    }
    
    func setupColors() {
        googleContainterView.backgroundColor = .buttonColor
        googleContainterView.layer.cornerRadius = 5
        onboardingTitleLabel.textColor = .textColor
        onboardingMessageLabel.textColor = .textColor
        emailLabel.textColor = .lightTextColor
        emailTextField.textColor = .textColor
        emailWarningLabel.textColor = .warningTextColor
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
        activeTextField = textField
        switch textField {
        case emailTextField:
            UIView.animate(withDuration: 0.2) {  [weak self] in
                guard let self else { return }
                emailLabel.isHidden = false
                emailTextField.placeholder = nil
            }
        case passwordTextField:
            UIView.animate(withDuration: 0.2) {  [weak self] in
                guard let self else { return }
                passwordLabel.isHidden = false
                passwordTextField.placeholder = nil
            }
        default:
            break
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.isHidden = true
            emailTextField.placeholder = L10nGeneric.email.localized()
        case passwordTextField:
            passwordLabel.isHidden = true
            passwordTextField.placeholder = L10nGeneric.password.localized()
        default:
            break
        }
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            guard
                let text = emailTextField.text,
                !text.isEmpty,
                !text.isValidEmail
            else {
                emailWarningLabel.text = ""
                return
            }
            emailWarningLabel.text = L10nGeneric.emailWarning.localized()
            
        default:
            break
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range(range, in: textField.text ?? "") {
            let updatedText = textField.text?.replacingCharacters(in: textRange, with: string)
            textField.text = updatedText?.withoutSpaces
        }
        return false
    }
}


