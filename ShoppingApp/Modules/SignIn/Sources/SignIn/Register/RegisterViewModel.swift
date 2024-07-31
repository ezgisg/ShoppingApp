//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import FirebaseFirestore
import Foundation
import TabBar

//MARK: - RegisterViewModelProtocol
protocol RegisterViewModelProtocol: AnyObject {
    var isSelectedMembershipAggrementCheckBox: Bool { get set }
    func determinePasswordValidationMessage(password: String, name: String?, surname: String?)  -> String?
    func addUserInfosToFirestore(uid: String, name: String, surname: String) async
    
}

//MARK: - RegisterViewModelDelegate
protocol RegisterViewModelDelegate: AnyObject {
    func didAddUserInfos()
    func didFailToAddUserInfos(error: Error)
}

//MARK: - RegisterViewModel
final class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?
    var isSelectedMembershipAggrementCheckBox = false
}

//MARK: - RegisterViewModelProtocol
extension RegisterViewModel: RegisterViewModelProtocol {
    ///Recording user name&surname infos to firebase firestore
    func addUserInfosToFirestore(uid: String, name: String, surname: String) async {
        let db = Firestore.firestore()
        Task {
            do {
                try await db.collection("users").document(uid).setData([
                    "name": name,
                    "surname": surname,
                    "uid": uid
                ])
                DispatchQueue.main.async {  [weak self] in
                    guard let self else { return }
                    delegate?.didAddUserInfos()
                }
            } catch {
                DispatchQueue.main.async {  [weak self] in
                    guard let self else { return }
                    self.delegate?.didFailToAddUserInfos(error: error)
                }
            }
        }
    }
    
    ///To check password does not meet the which condition
    func determinePasswordValidationMessage(password: String, name: String?, surname: String?) -> String? {
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
