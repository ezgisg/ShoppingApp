//
//  ProductDetailViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 21.08.2024.
//

import UIKit

// MARK: - Enums
enum ProductDetailSectionType: Int, CaseIterable {
    case product = 0
    case variant = 1
    case details = 2
    case suggestions = 3
    case payment = 4
    
    var stringValue: String? {
        switch self {
        case .product:
            "product"
        case .variant:
            "variant"
        case .details:
            "details"
        case .suggestions:
            "suggestions"
        case .payment:
            "payment"
        }
    }
}
    
class ProductDetailViewController: UIViewController {
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomBackView: UIView!
    @IBOutlet private weak var addCartButton: UIButton!
    
    var productID: Int
    
    // MARK: - Module Components
    public var viewModel = ProductDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setups()
        viewModel.fetchProduct(productId: productID)
    }
    
    // MARK: - Module init
    public init(productID: Int) {
        self.productID = productID
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func tappedAddButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("basıldı")
    }
    
}

extension ProductDetailViewController {
    final func setups() {
        setupCollectionView()
    }
    
    
    final func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: ProductDetailCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = ProductDetailSectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .product:
                return createProductSection()
            case .variant:
                return createProductSection()
            case .details:
                return createProductSection()
            case .suggestions:
                return createProductSection()
            case .payment:
                return createProductSection()

            }
        }
    }
    
    final func createProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)
        return section
    }
    
}

extension ProductDetailViewController: UICollectionViewDelegate {
    
}


extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = ProductDetailSectionType(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .product:
            return viewModel.product != nil ? 1 : 0
        case .variant:
            return 0
        case .details:
            return 0
        case .suggestions:
            return 0
        case .payment:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProductDetailCell.self, for: indexPath)
        cell.configureWith(product: viewModel.product)
        return cell
    }
    
}


extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}