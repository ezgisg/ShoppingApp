//
//  TabBarController.swift.swift
//
//
//  Created by Ezgi Sümer Günaydın on 24.07.2024.
//

import AppResources
import AppManagers
import Cart
import Categories
import Campaigns
import Combine
import Favorites
import Foundation
import Home
import UIKit

// MARK: - TabBarController
public class TabBarController: UITabBarController, UITabBarControllerDelegate {

    let circleInsideImage = UIImageView(image: UIImage.tabbarCircle)
    let tabBarItemCount: CGFloat = 5
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
        setupTabbar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )
        getCartItemsWithCombine()
    }
}

//MARK: Configuration
private extension TabBarController {
    ///Determining tabbar view controllers
    final func setupTabbar() {
        tabBar.items?[2].isEnabled = false
        customizeTabBarAppearance()
        setupMiddleButton()
    }
    
    final func setupMiddleButton() {
        let middleButtonOffset: CGFloat = 20
        let tabBarHeight = self.tabBar.frame.size.height
        let tabBarWidth = self.tabBar.frame.size.width
        let middleButtonWidth = min((tabBarWidth / tabBarItemCount), (tabBarHeight + middleButtonOffset))
     
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - (middleButtonWidth / 2), y: -middleButtonOffset, width: middleButtonWidth, height: middleButtonWidth))

        middleButton.setBackgroundImage(UIImage.systemCircleImage, for: .normal)
        middleButton.tintColor = .middleButtonColor
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        let circleInsideImageWidth = middleButtonWidth - (middleButtonOffset * 2 )
        circleInsideImage.frame = CGRect(x: middleButtonOffset, y: middleButtonOffset, width: circleInsideImageWidth, height: circleInsideImageWidth)
        middleButton.addSubview(circleInsideImage)

        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
    }
    
    @objc final func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
        setSelected(isSelected: true)
    }
    
    final func setSelected(isSelected: Bool) {
        if isSelected {
            circleInsideImage.image = .tabbarCircleSelected
        } else {
            circleInsideImage.image = .tabbarCircle
        }
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
    
    final func getCartItemsWithCombine() {
        CartManager.shared.cartItemsPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: {  [weak self] cart in
                guard let self else { return }
                let basketIndex = 3
                let basketTabBarItem = tabBar.items?[basketIndex]
                let cartItemCount = cart.reduce(0) { $0 + ($1.quantity ?? 0) }
                if cartItemCount > 0 {
                    basketTabBarItem?.badgeValue = "\(cartItemCount)"
                } else {
                    basketTabBarItem?.badgeValue = nil
                }
            }).store(in: &cancellables)
    }
}

//MARK: TabBarController didSelect control
public extension TabBarController {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.selectedIndex == 2 {
            setSelected(isSelected: true)
        } else {
            setSelected(isSelected: false)
        }
    }
}

