//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import Foundation

protocol RegisterViewModelProtocol: AnyObject {
    var isSelectedMembershipAggrementCheckBox: Bool { get set }
    
}

protocol RegisterViewModelDelegate: AnyObject {
    
}

final class RegisterViewModel {
    var isSelectedMembershipAggrementCheckBox = false
}


extension RegisterViewModel: RegisterViewModelProtocol {

}
