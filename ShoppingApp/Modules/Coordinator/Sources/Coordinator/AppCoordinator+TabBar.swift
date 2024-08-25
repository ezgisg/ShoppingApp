//
//  AppCoordinator+TabBar.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import Foundation
import Base
import TabBar

extension AppCoordinator {
    public func routeToTabBar(_ from: BaseCoordinator) {
        removeAllChildCoordinators()
        let coordinator = TabBarCoordinator(navigationController)
        coordinator.delegate = self
        start(child: coordinator)
        window?.switchRootViewController(to: navigationController)
    }
}
