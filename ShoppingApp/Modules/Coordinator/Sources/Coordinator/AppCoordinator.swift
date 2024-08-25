//
//  AppCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.08.2024.
//

import UIKit
import Base
import ProductList
import Favorites
import Campaigns
import Cart
import Home
import TabBar
import Categories
import Splash
import Onboarding
import SignIn

typealias Routes = SplashRouter
& HomeRouter
& TabBarRouter
& CategoriesRouter
& CartRouter
& FavoritesRouter

public final class AppCoordinator: BaseCoordinator, Routes {
    weak var window: UIWindow?

    required public init(
        _ navigationController: UINavigationController = UINavigationController(),
        window: inout UIWindow?
    ) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        self.window = window
        super.init(navigationController)
    }

    public override func start() {
        routeToSplash()
    }
}
