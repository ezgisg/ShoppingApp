//
//  ProductListViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import UIKit

// MARK: - ProductListViewController
public class ProductListViewController: UIViewController {

    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var orderingImage: UIImageView!
    @IBOutlet weak var orderingLabel: UILabel!
    @IBOutlet weak var bigLayoutImage: UIImageView!
    @IBOutlet weak var smallLayoutImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterAreaStackView: UIStackView!
    
    var category = String()
 
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("Selected category: \(category)")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }

    // MARK: - Module init
    public init(category: String) {
        self.category = category
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}


private extension ProductListViewController {
    final func setupUI() {
        containerView.backgroundColor = .tabbarBackgroundColor
        applyGradientToFilterArea()
        filterImage.image = .filter
        filterLabel.text = L10nGeneric.filter.localized()
        orderingImage.image = .sorting
        orderingLabel.text = L10nGeneric.sorting.localized()
        smallLayoutImage.image = .smallLayout
        bigLayoutImage.image = .bigLayout
        filterAreaStackView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        filterAreaStackView.layer.borderWidth = 1
    }
    
    private func applyGradientToFilterArea() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = filterAreaStackView.bounds
        gradientLayer.cornerRadius = filterAreaStackView.layer.cornerRadius
        filterAreaStackView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientFrame() {
        if let gradientLayer = filterAreaStackView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = filterAreaStackView.bounds
        }
    }
}
