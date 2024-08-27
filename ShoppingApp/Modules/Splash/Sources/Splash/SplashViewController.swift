//
//  SplashViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import AppResources
import Base
import Lottie
import UIKit

// MARK: - Module init
public class SplashViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var animationContainerView: UIView!
    @IBOutlet private weak var appNameLabel: UILabel!
    
    // MARK: - Private Variables
    var coordinator: SplashCoordinator
    private var animationView: LottieAnimationView?
    private let isFirstLaunch = UserDefaults.standard.object(forKey: Constants.UserDefaults.isFirstLaunch)
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimation()
        startAnimation()
    }

    // MARK: - Module init
    public init(
        coordinator: SplashCoordinator
    ) {
        self.coordinator = coordinator
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Functions that manage the splash flow
private extension SplashViewController {
    final func setupUI() {
        appNameLabel.text = L10nGeneric.appName.localized(in: AppResources.bundle)
        appNameLabel.textColor = .lightButtonColor
        mainView.backgroundColor = .lightBackgroundColor
        animationContainerView.backgroundColor = .clear
    }

    final func setupAnimation() {
        guard let animation = LottieAnimation.named("splashLottie", bundle: AppResources.bundle) else {
            showSplashImage()
            return }
        animationView = LottieAnimationView(animation: animation)
        animationView?.frame = animationContainerView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce
        if let animationView {
            animationContainerView.addSubview(animationView)

        }
    }

    final func startAnimation() {
        appNameLabel.isHidden = true
        animationView?.play { [weak self] finished in
            guard let self,
                  finished else { return }
            hideAnimation()
        }
    }
    
    final func hideAnimation() {
        animationContainerView.fadeOut(duration: 1) { [weak self] _ in
            guard let self else { return }
            animationView?.removeFromSuperview()
            showSplashImage()
        }
    }
    
    final func showSplashImage() {
        appNameLabel.isHidden = false
        appNameLabel.fadeOut(duration: 0)
        appNameLabel.fadeIn()
        let containerImageView = UIImageView(image: UIImage.systemCircleImage)
        containerImageView.frame = animationContainerView.bounds
        containerImageView.tintColor = .lightButtonColor
        animationContainerView.addSubview(containerImageView)
        let imageView = UIImageView(image: UIImage.splashImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = containerImageView.bounds
        containerImageView.addSubview(imageView)
        animationContainerView.fadeIn(duration: 1) {  [weak self] _ in
            guard let self else { return }
            hideSplashImage()
        }
    }
    
    final func hideSplashImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  [weak self] in
            guard let self else { return }
            appNameLabel.fadeOut()
            animationContainerView.fadeOut {  [weak self] _ in
                guard let self else { return }
                animationContainerView.removeFromSuperview()
                appNameLabel.fadeIn() {  [weak self] _ in
                    guard let self else { return }
                    navigateToNextScreen()
                }
            }
        }
    }
    
    final func navigateToNextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  [weak self] in
            guard let self else { return }
            if let isFirst = isFirstLaunch as? Bool,
               !isFirst {
                coordinator.routeToSignIn()
            } else {
                coordinator.routeToOnboarding()
            }
        }
    }
}

