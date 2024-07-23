//
//  SignInViewModel.swift
//
//
//  Created by Ezgi Sümer Günaydın on 22.07.2024.
//

import Foundation

protocol SignInViewModelProtocol: AnyObject {
    func isValidEmail(_ email: String) -> Bool
}

protocol SignInViewModelDelegate: AnyObject {
    
}

final class SignInViewModel {
    
}

extension SignInViewModel: SignInViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
