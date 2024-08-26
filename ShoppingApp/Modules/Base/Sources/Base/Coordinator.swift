//
//  Coordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    var navigationController: UINavigationController { get set }

    func start()
    func start(child coordinator: Coordinator)
    func start(_ coordinator: Coordinator)

    func back()

    func addChildCoordinator(_ coordinator: Coordinator)
    func removeAllChildCoordinators()
}

public extension Coordinator {
    func start() {
        fatalError("\(#function) should be implemented.")
    }

    func start(child coordinator: Coordinator) {
        addChildCoordinator(coordinator)
        start(coordinator)
    }

    func start(_ coordinator: Coordinator) {
        if coordinator.parentCoordinator == nil {
            coordinator.parentCoordinator = self
        }
        coordinator.start()
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }

    func removeAllChildCoordinators() {
        childCoordinators.forEach { $0.removeAllChildCoordinators() }
        childCoordinators.removeAll()
    }

}
