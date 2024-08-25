//
//  TabBarCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import AppResources
import Foundation
import Base
import Cart
import Categories
import Campaigns
import Favorites
import Home
import UIKit

// MARK: - CoordinatorRoutingDelegate
public typealias TabBarRoutes = HomeRouter 
& CategoriesRouter
& CampaignsRouter
& CartRouter
& FavoritesRouter
public protocol TabBarRouter: TabBarRoutes {}

// MARK: - TabBarCoordinator
public final class TabBarCoordinator: BaseCoordinator {
    // MARK: - Privates
    private weak var tabBarController: TabBarController?

    // MARK: - Publics
    public weak var delegate: TabBarRouter? {
        didSet {
            homeCoordinator.delegate = delegate
            categoriesCoordinator.delegate = delegate
            campaignsCoordinator.delegate = delegate
            cartCoordinator.delegate = delegate
            favoritesCoordinator.delegate = delegate
        }
    }

    public let homeCoordinator: HomeCoordinator
    public let categoriesCoordinator: CategoriesCoordinator
    public let campaignsCoordinator: CampaignsCoordinator
    public let cartCoordinator: CartCoordinator
    public let favoritesCoordinator: FavoritesCoordinator

    public var coordinators: [BaseCoordinator] {
        return [
            homeCoordinator,
            categoriesCoordinator,
            campaignsCoordinator,
            cartCoordinator,
            favoritesCoordinator
        ]
    }

    // MARK: - Init
    override public init(_ navigationController: UINavigationController) {
        func getStyledNavigationController(title: String, image: UIImage?, isNeededRendering: Bool? = false, titleColor: UIColor = .buttonTextColor ) -> UINavigationController {
            let navigationController = UINavigationController()
            var resizedImage = image
            if let image,
               let isNeededRendering,
               isNeededRendering {
                resizedImage = UIImage.resizeImage(image: image, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
            }
            navigationController.tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: 0)
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: titleColor
            ]
            return navigationController
        }
        
        let homeTitle = L10nGeneric.home.localized(in: AppResources.bundle)
        let homeNavigationController = getStyledNavigationController(title: homeTitle, image: .systemHouseImage)
        homeCoordinator = HomeCoordinator(homeNavigationController)
        
        let categoriesTitle = L10nGeneric.categories.localized(in: AppResources.bundle)
        let categoriesNavigationController = getStyledNavigationController(title: categoriesTitle, image: .systemListImage)
        categoriesCoordinator = CategoriesCoordinator(categoriesNavigationController)

        let middleNavigationController = getStyledNavigationController(title: "", image: nil)
        campaignsCoordinator = CampaignsCoordinator(middleNavigationController)

        let basketTitle = L10nGeneric.basket.localized(in: AppResources.bundle)
        let basketNavigationController = getStyledNavigationController(title: basketTitle, image: .systemCartImage)
        cartCoordinator = CartCoordinator(basketNavigationController)

        let favoritesTitle = L10nGeneric.favorites.localized(in: AppResources.bundle)
        let favoritesNavigationController = getStyledNavigationController(title: favoritesTitle, image: .systemHeartImage)
        favoritesCoordinator = FavoritesCoordinator(favoritesNavigationController)

        super.init(navigationController)
    }

    // MARK: - Start
    public override func start() {
        let controller = TabBarController()
        var viewControllers: [UIViewController] = []
        coordinators.forEach {
            viewControllers.append($0.navigationController)
            start(child: $0)
        }
        controller.viewControllers = viewControllers
        tabBarController = controller
        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Public
    final public func selectTab(at index: Int) {
        tabBarController?.selectedIndex = index
    }
}
