//
//  Coordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit

@MainActor
public protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var parentCoordinator: CoordinatorProtocol? { get set }

    var navigationController: UINavigationController { get set }

    func start()
    func start(child coordinator: CoordinatorProtocol)
    func start(_ coordinator: CoordinatorProtocol)

    func back()

    func addChildCoordinator(_ coordinator: CoordinatorProtocol)
    func removeAllChildCoordinators()
}

public extension CoordinatorProtocol {
    func start() {
        fatalError("\(#function) should be implemented.")
    }

    func start(child coordinator: CoordinatorProtocol) {
        addChildCoordinator(coordinator)
        start(coordinator)
    }

    func start(_ coordinator: CoordinatorProtocol) {
        if coordinator.parentCoordinator == nil {
            coordinator.parentCoordinator = self
        }
        coordinator.start()
    }

    func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }

    func removeAllChildCoordinators() {
        childCoordinators.forEach { $0.removeAllChildCoordinators() }
        childCoordinators.removeAll()
    }

}
