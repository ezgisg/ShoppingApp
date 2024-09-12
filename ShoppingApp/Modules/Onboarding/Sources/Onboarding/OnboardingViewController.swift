//
//  OnboardingViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//


import AppResources
import UIKit

// MARK: - Enums
enum RouteType {
    case tabBar
    case signIn
}

// MARK: - OnboardingViewController
final class OnboardingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var skipButtonLabel: UILabel!
    @IBOutlet private weak var nextButtonLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var bottomView: UIImageView!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var gapView: UIView!
    
    // MARK: - Private Variables
    private let isFirstLaunch = UserDefaults.standard.object(forKey: Constants.UserDefaults.isFirstLaunch)
    private var pageVC = UIPageViewController()
    private var controllers = [UIViewController]()
    private let pages: [welcomeMessage] = [
        welcomeMessage(image: .welcomeImage, title: L10nOnboarding.OnboardingTitleMessage.first.localized(), description: L10nOnboarding.OnboardingDetailMessage.first.localized()),
        welcomeMessage(image: .browseImage, title: L10nOnboarding.OnboardingTitleMessage.second.localized(), description: L10nOnboarding.OnboardingDetailMessage.second.localized()),
        welcomeMessage(image: .checkoutImage, title: L10nOnboarding.OnboardingTitleMessage.third.localized(), description: L10nOnboarding.OnboardingDetailMessage.third.localized())
    ]
    
    // MARK: - Module Components
    private var coordinator: OnboardingCoordinator
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupUI()
    }
    
    // MARK: - Module init
    init(
        coordinator: OnboardingCoordinator
    ) {
        self.coordinator = coordinator
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
        let visibleViewController = pageViewController.viewControllers?.first,
        let index = controllers.firstIndex(of: visibleViewController) {
            pageControl.currentPage = index
            setupLastonboardingScreen(index: index)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else {return nil}
        let previous = index - 1
        return controllers[previous]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else {return nil}
        let next = index + 1
        return controllers[next]
    }
    
}

// MARK: - Setups
private extension OnboardingViewController {
    final func createControllers() {
        for page in pages {
            let controller =  PageViewController(sendedImage: page.image, sendedTitle: page.title, sendedDescription: page.description)
            controllers.append(controller)
        }
    }
    
    final func setupPageViewController() {
        createControllers()
        
        guard let first = controllers.first else { return }
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.setViewControllers([first], direction: .forward, animated: true)
        contentView.addSubview(pageVC.view)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                pageVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                pageVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                pageVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                pageVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ]
        )
        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = 0
    }
    
    final func setupUI() {
        bottomView.backgroundColor = .lightButtonColor
        gapView.backgroundColor = .clear
        bottomView.isHidden = true
        startLabel.isHidden = true
     
        view.backgroundColor = .backgroundColor
        
        skipButtonLabel.textColor = .textColor
        nextButtonLabel.textColor = .textColor
        startLabel.textColor = .textColor
        
        skipButtonLabel.text = L10nOnboarding.skip.localized()
        nextButtonLabel.text = L10nOnboarding.next.localized()
        startLabel.text = L10nOnboarding.letsStart.localized()
        
        skipButtonLabel.isUserInteractionEnabled = true
        nextButtonLabel.isUserInteractionEnabled = true
        bottomView.isUserInteractionEnabled = true
        
        let skipTapGesture = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextTapped))
        let bottomTapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomTapped))
        
        skipButtonLabel.addGestureRecognizer(skipTapGesture)
        nextButtonLabel.addGestureRecognizer(nextTapGesture)
        bottomView.addGestureRecognizer(bottomTapGesture)
    }
    
    @objc private func skipTapped() {
        //TODO: false olmalı bir kez göstermek için
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isFirstLaunch)
        navigateToNextScreen(to: .tabBar)
        //TODO: sign in screen e gidilecek eğer giriş yapıldıysa atlanacak home a gidecek, hızlı gidiş için şimdilik direkt tabbar bırakıldı
    }
    
    @objc private func nextTapped() {
        let nextIndex = pageControl.currentPage + 1
        guard let nextVC = controllers[safe: nextIndex] else { return }
        pageControl.currentPage = nextIndex
        pageVC.setViewControllers([nextVC], direction: .forward, animated: true)
        setupLastonboardingScreen(index: nextIndex)
    }
    
    @objc private func bottomTapped() {
        //TODO: false olmalı bir kez göstermek için
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isFirstLaunch)
        //TODO: sign in screen e gidilecek eğer giriş yapıldıysa atlanacak home a gidecek
        navigateToNextScreen(to: .signIn)
    }
    
    final func setupLastonboardingScreen(index: Int) {
       guard index == controllers.count - 1 else {
           skipButtonLabel.isHidden = false
           nextButtonLabel.isHidden = false
           bottomView.isHidden = true
           startLabel.isHidden = true
           gapView.backgroundColor = .clear
           return
       }
        skipButtonLabel.isHidden = true
        nextButtonLabel.isHidden = true
        gapView.backgroundColor = bottomView.backgroundColor
        bottomView.isHidden = false
        startLabel.isHidden = false
    }
    
}

//MARK: Navigation
private extension OnboardingViewController {
    final func navigateToNextScreen(to route: RouteType) {
        switch route {
        case .tabBar:
            coordinator.routeToTabBar()
        case .signIn:
            coordinator.routeToSignIn()
        }
    }
}
