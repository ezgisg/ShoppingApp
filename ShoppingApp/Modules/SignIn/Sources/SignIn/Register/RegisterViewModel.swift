//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import Foundation

protocol RegisterViewModelProtocol: AnyObject {
    var isSelectedMembershipAggrementCheckBox: Bool { get set }
    func isPasswordValid(password: String, name: String?, surname: String?)  -> String?
    
}

protocol RegisterViewModelDelegate: AnyObject {
    
}

final class RegisterViewModel {
    var isSelectedMembershipAggrementCheckBox = false
}


extension RegisterViewModel: RegisterViewModelProtocol {
    func isPasswordValid(password: String, name: String?, surname: String?) -> String? {
        var message: String? = nil
        guard !password.isEmpty else { return nil }
        if !password.hasNumbers {
            message = L10nGeneric.PasswordControlMessages.number.localized()
        } else if !password.hasLetters {
            message = L10nGeneric.PasswordControlMessages.letter.localized()
        } else if !password.hasSpecialCharacters {
            message = L10nGeneric.PasswordControlMessages.special.localized()
        } else if password.hasConsecutiveDigits {
            message = L10nGeneric.PasswordControlMessages.consecutive.localized()
        } else if password.hasRepeatingDigits {
            message = L10nGeneric.PasswordControlMessages.repeating.localized()
        } else if let name, password.lowercased().contains(name.lowercased()) {
            message = L10nGeneric.PasswordControlMessages.nameContain.localized()
        } else if let surname, password.lowercased().contains(surname.lowercased()) {
            message = L10nGeneric.PasswordControlMessages.surnameContain.localized()
        } else if password.count < 8 {
            message = L10nGeneric.PasswordControlMessages.minCharacter.localized()
        } else if password.count > 16 {
            message = L10nGeneric.PasswordControlMessages.maxCharacter.localized()
        } else {
            message = nil
        }
        return message
    }
}
