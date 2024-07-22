//
//  SignInViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.07.2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

public class SignInViewController: UIViewController {

    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleAuth()
    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

//MARK: - Setups
extension SignInViewController {
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
}
