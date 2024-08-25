//
//  AppCoordinator+SignIn.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import Base
import SignIn

public extension AppCoordinator {
    func routeToSignIn(_ from: BaseCoordinator) {
        let coordinator = SignInCoordinator(
            from.navigationController
        )
        coordinator.delegate = self
        
        from.start(child: coordinator)
    }
}
