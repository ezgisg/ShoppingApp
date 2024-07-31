//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import Foundation

protocol RegisterViewModelProtocol: AnyObject {
    var isSelectedMembershipAggrementCheckBox: Bool { get set }
    func isValidEmail(_ email: String) -> Bool
    
}

protocol RegisterViewModelDelegate: AnyObject {
    
}

final class RegisterViewModel {
    var isSelectedMembershipAggrementCheckBox = false
}


extension RegisterViewModel: RegisterViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
