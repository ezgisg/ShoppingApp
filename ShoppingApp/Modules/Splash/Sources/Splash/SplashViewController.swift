//
//  SplashViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import AppResources
import Lottie
import UIKit

// MARK: - Module init
public class SplashViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    private var animationView: LottieAnimationView?
    @IBOutlet weak var appNameLabel: UILabel!
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimation()
        startAnimation()
    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI() {
        appNameLabel.text = "Shopping App"
        appNameLabel.textColor = .black
        mainView.backgroundColor = .white
        animationContainerView.backgroundColor = .clear
    }
   
    private func setupAnimation() {
        guard let animation = LottieAnimation.named("splashLottie", bundle: AppResources.bundle) else {
            //TODO: Label'ı gösterelim
            return
        }
        animationView = LottieAnimationView(animation: animation)
        animationView?.frame = animationContainerView.bounds
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .playOnce
        if let animationView {
            animationContainerView.addSubview(animationView)
        }
    }

    private func startAnimation() {
        appNameLabel.isHidden = true
        animationView?.play { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.hideAnimation()
            }
        }

    }
    
    private func hideAnimation() {
        animationContainerView.fadeOut(duration: 1) { _ in
            self.appNameLabel.isHidden = false
            self.animationView?.removeFromSuperview()
      
            let imageView = UIImageView(image: UIImage.splashImage)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = self.animationContainerView.bounds
            self.animationContainerView.addSubview(imageView)
            self.animationContainerView.fadeIn()
            self.appNameLabel.fadeIn()
        }
        

  
    }

}


public extension UIView {
    func fadeIn(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    func fadeOut(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
