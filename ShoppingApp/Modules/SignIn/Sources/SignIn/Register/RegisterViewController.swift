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
    @IBOutlet weak var informationContainerView: UIView!

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet weak var secondCheckBoxView: CheckBoxView!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        checkBoxView.configureWith(initialImage: .browseImage, secondImage: .welcomeImage, textContent: L10nSignIn.PrivacyPolicy.longTitle.localized(), boldContent: L10nSignIn.PrivacyPolicy.title.localized(), isCheckBoxImageNeeded: false)
        secondCheckBoxView.configureWith(initialImage: .browseImage, secondImage: .welcomeImage, textContent: L10nSignIn.MembershipAgreement.longTitle.localized(), boldContent: L10nSignIn.MembershipAgreement.title.localized(), isCheckBoxImageNeeded: true)
        registerButton.setTitle(L10nSignIn.register.localized(), for: .normal)

    }
    
    final func setupColor() {
        registerButton.backgroundColor = .buttonColor
        registerButton.setTitleColor(.buttonTextColor, for: .normal)
//        informationContainerView.backgroundColor = .backgroundColor
        applyGradient(view: containerView)

    }
    
    final func setupUI() {
        setupText()
        setupColor()
        
        topImageView.image = .registerImage

    }
    
    private func applyGradient(view: UIView) {
          
          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = view.bounds
          gradientLayer.colors = [
            UIColor.lightButtonColor!.cgColor,
            UIColor.buttonColor!.cgColor,
            UIColor.backgroundColor.cgColor
          ]
          gradientLayer.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0] // Renklerin geçiş noktaları
          
          // Gradient'ı topView'a ekleme
          view.layer.insertSublayer(gradientLayer, at: 0)
      }
    
      
}
