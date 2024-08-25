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

    func removeChildCoordinator(_ coordinator: Coordinator)
    func removeAllChildCoordinators()

    func getCoordinator<T: Coordinator>(_ coordinator: T.Type) -> T?
    func getParentCoordinator<T: Coordinator>(_ coordinator: T.Type) -> T?
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

    func removeChildCoordinator(_ coordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        childCoordinators.remove(at: index)
    }

    func removeAllChildCoordinators() {
        childCoordinators.forEach { $0.removeAllChildCoordinators() }
        childCoordinators.removeAll()
    }

    func getCoordinator<T: Coordinator>(_ coordinator: T.Type) -> T? {
        return childCoordinators.last { $0 is T } as? T
    }

    func getParentCoordinator<T: Coordinator>(_ coordinator: T.Type) -> T? {
        guard let parent = parentCoordinator else { return nil }
        if let pCoordinator = parent as? T {
            return pCoordinator
        } else {
            return parent.getParentCoordinator(coordinator)
        }
    }
}
