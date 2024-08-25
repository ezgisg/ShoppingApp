//
//  AppCoordinator+OnBoarding.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import Base
import Onboarding

public extension AppCoordinator {
    func routeToOnboarding(_ from: BaseCoordinator) {
        let coordinator = OnboardingCoordinator(
            from.navigationController
        )
        coordinator.delegate = self
        
        from.start(child: coordinator)
    }
}
