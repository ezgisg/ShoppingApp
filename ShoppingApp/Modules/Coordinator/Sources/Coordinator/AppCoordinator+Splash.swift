//
//  AppCoordinator+Splash.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import Foundation
import Splash


extension AppCoordinator {
    public func routeToSplash() {
        removeAllChildCoordinators()
        let coordinator = SplashCoordinator(navigationController)
        coordinator.delegate = self
        start(child: coordinator)
        window?.switchRootViewController(to: navigationController)
    }
}
