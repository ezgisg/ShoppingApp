//
//  TabBarController.swift.swift
//
//
//  Created by Ezgi Sümer Günaydın on 24.07.2024.
//

import AppResources
import Foundation
import SignIn
import UIKit

// MARK: - TabBarController
public class TabBarController: UITabBarController, UITabBarControllerDelegate {

    let circleInsideImage = UIImageView(image: UIImage.tabbarCircle)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
        setupTabbar()
        setupMiddleButton()
    }
}
extension TabBarController {

    //TODO: Oluşturulduğunde gerçek ekranlara atanacak
    final func setupTabbar() {
        
        let homeTitle = L10nGeneric.home.localized(in: AppResources.bundle)
        let homeVC = SignInViewController()
        let homeNavigationController = getStyledNavigationController(with: homeVC, title: homeTitle, image: .systemHouseImage)
        
        
        let categoriesTitle = L10nGeneric.categories.localized(in: AppResources.bundle)
        let categoriesVC = SignInViewController()
        let categoriesNavigationController = getStyledNavigationController(with: categoriesVC, title: categoriesTitle, image: .systemListImage)

        let middleVC = MiddleViewController()
        let middleNavigationController = getStyledNavigationController(with: middleVC, title: "", image: nil)

        let basketTitle = L10nGeneric.basket.localized(in: AppResources.bundle)
        let basketVC = SignInViewController()
        let basketNavigationController = getStyledNavigationController(with: basketVC, title: basketTitle, image: .systemCartImage)

        let favoritesTitle = L10nGeneric.favorites.localized(in: AppResources.bundle)
        let favoritesVC = SignInViewController()
        let favoritesNavigationController = getStyledNavigationController(with: favoritesVC, title: favoritesTitle, image: .systemHeartImage)

        viewControllers = [homeNavigationController, categoriesNavigationController, middleNavigationController, basketNavigationController, favoritesNavigationController]
        
        tabBar.items?[2].isEnabled = false
        customizeTabBarAppearance()
    }
}

extension TabBarController {
    func setupMiddleButton() {
        
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 35, y: -20, width: 70, height: 70))

        middleButton.setBackgroundImage(UIImage.systemCircleImage, for: .normal)
        middleButton.tintColor = .middleButtonColor
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        circleInsideImage.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
        middleButton.addSubview(circleInsideImage)

        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
    }

    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
        setSelected(isSelected: true)
        }
        
        func setSelected(isSelected: Bool) {
            if isSelected {
                circleInsideImage.image = .tabbarCircleSelected
            } else {
                circleInsideImage.image = .tabbarCircle
            }
        }
        
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.selectedIndex == 2 {
            setSelected(isSelected: true)
        } else {
            setSelected(isSelected: false)
        }
    }

    final func getStyledNavigationController(with viewController: UIViewController, title: String, image: UIImage?, isNeededRendering: Bool? = false) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        var resizedImage = image
        if let image,
           let isNeededRendering,
           isNeededRendering {
            resizedImage = UIImage.resizeImage(image: image, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
        }
        navigationController.tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: 0)
        return navigationController
    }
    
    final func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.buttonTextColor]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedColor]
        tabBarItemAppearance.normal.iconColor = .buttonTextColor
        tabBarItemAppearance.selected.iconColor = .tabbarSelectedColor
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.backgroundColor = UIColor.tabbarBackgroundColor
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
}

//TODO: ekran kaldırılacak gerçeği oluşturulunca
// Dummy MiddleViewController for the middle button
class MiddleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
}

