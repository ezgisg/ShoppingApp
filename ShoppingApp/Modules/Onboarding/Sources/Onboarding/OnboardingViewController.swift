//
//  OnboardingViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//


import AppResources
import UIKit

public class OnboardingViewController: UIViewController {

    @IBOutlet weak var skipButtonLabel: UILabel!
    @IBOutlet weak var nextButtonLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    
    private var pageVC = UIPageViewController()
    private var controllers = [UIViewController]()
    
    let pages: [(image: UIImage, title: String, description: String)] = [
        (.loginImage ?? UIImage(), "Welcome to the app!", "1"),
        (.splashImage ?? UIImage(), "Learn how to use the app!", "2"),
        (.tabbarCircle ?? UIImage(), "Start using the app!", "3")
     ]
    
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.isHidden = true
        setupPageViewController()
        setupUI()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Module init
    public init() {
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
        bottomView.isHidden = true
        view.backgroundColor = .backgroundColor
        
        skipButtonLabel.text = "Skip"
        nextButtonLabel.text = "Next"
        
        let skipTapGesture = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextTapped))
        
        skipButtonLabel.addGestureRecognizer(skipTapGesture)
        nextButtonLabel.addGestureRecognizer(nextTapGesture)
    }
    
    @objc private func skipTapped() {
        print("Skip button tapped")
    }
    
    @objc private func nextTapped() {
        print("Next button tapped")
    }
    
    final func setupLastonboardingScreen(index: Int) {
       guard index == controllers.count - 1 else {
           skipButtonLabel.isHidden = false
           nextButtonLabel.isHidden = false
           bottomView.isHidden = true
           return
       }
        skipButtonLabel.isHidden = true
        nextButtonLabel.isHidden = true
        bottomView.isHidden = false
        bottomView.backgroundColor = .orange
        bottomView.layer.cornerRadius = 10
    }
    
}
