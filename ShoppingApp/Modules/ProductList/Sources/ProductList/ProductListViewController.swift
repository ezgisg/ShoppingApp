//
//  ProductListViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import UIKit

// MARK: - Enums
enum ProductListScreenSectionType: Int, CaseIterable, Hashable {
    case filter = 0
    case products = 1
    
    var stringValue: String? {
         switch self {
         case .filter:
             return "filter"
         case .products:
             return "products"
         }
     }
}

// MARK: - ProductListViewController
public class ProductListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var filterImage: UIImageView!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var orderingImage: UIImageView!
    @IBOutlet private weak var orderingLabel: UILabel!
    @IBOutlet private weak var bigLayoutImage: UIImageView!
    @IBOutlet private weak var smallLayoutImage: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterAreaStackView: UIStackView!
    
    // MARK: - Variables
    var category = String()
    var categories = [CategoryResponseElement]()
    
    // MARK: - Private Variables
    private var dataSource: UICollectionViewDiffableDataSource<ProductListScreenSectionType, AnyHashable>?
    
    // MARK: - Module Components
    private var viewModel = ProductListViewModel()
 
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        viewModel.delegate = self
        viewModel.fetchProducts(categoryName: category)
        viewModel.fetchCategories(categoryName: category)
    }
    
    // MARK: - Module init
    public init(category: String, categories: [CategoryResponseElement] = [CategoryResponseElement]()) {
        self.category = category
        self.categories = categories
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}

//MARK: - UI Setups
private extension ProductListViewController {
    final func setupUI() {
        containerView.backgroundColor = .tabbarBackgroundColor
        collectionView.backgroundColor = .white
        applyGradientToFilterArea()
        filterAreaStackView.backgroundColor = UIColor.lightGray
        filterAreaStackView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        filterAreaStackView.layer.borderWidth = 1
        
        orderingImage.image = .sorting
        smallLayoutImage.image = .smallLayout
        bigLayoutImage.image = .bigLayout
        filterImage.image = .filter
        
        filterLabel.text = L10nGeneric.filter.localized()
        filterLabel.textColor = .darkGray
        orderingLabel.text = L10nGeneric.sorting.localized()
        orderingLabel.textColor = .darkGray
        
        navigationController?.navigationBar.tintColor = .tabbarSelectedColor
    }
    
    final func applyGradientToFilterArea() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .init(
            x: filterAreaStackView.bounds.minX,
            y: filterAreaStackView.bounds.minY,
            ///It doesn't get the correct size when called in didload with "filterAreaStackView.bounds", we could update it in viewDidLayoutSubviews but in this case the gradient appears to fill after the screen is opened
            width: UIScreen.main.bounds.width,
            height: filterAreaStackView.bounds.height
        )
        gradientLayer.cornerRadius = filterAreaStackView.layer.cornerRadius
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        filterAreaStackView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    final func setupCollectionView() {
        configureDatasource()
        collectionView.register(nibWithCellClass: ProductCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: FilterCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func setups() {
        setupUI()
        setupCollectionView()
    }
}

//MARK: - Diffable Data Source
private extension ProductListViewController {
    final func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self,
                  let sectionType = ProductListScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch sectionType {
            case .filter:
                let cell = collectionView.dequeueReusableCell(withClass: FilterCell.self, for: indexPath)
                cell.configureWith(text: categories[indexPath.row].value ?? "")
                return cell
            case .products:
                let cell = collectionView.dequeueReusableCell(withClass: ProductCell.self, for: indexPath)
                let data = viewModel.filteredProducts[indexPath.row]
                cell.configure(withRating: data.rating?.rate , ratingCount: data.rating?.count, categoryName: data.category, productName: data.title, price: data.price, imagePath: data.image)
                return cell
            }
        })
        applySnapshot()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListScreenSectionType, AnyHashable>()
        for section in ProductListScreenSectionType.allCases {
            snapshot.appendSections([section]) }
        snapshot.appendItems(categories, toSection: .filter)
        snapshot.appendItems(viewModel.filteredProducts, toSection: .products)
        dataSource?.apply(snapshot)
    }
    
}

// MARK: - Compositional Layout
private extension ProductListViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = ProductListScreenSectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .filter:
                return createFilterSection()
            case .products:
                return createProductSection()
            }
        }
    }
    
    final func createFilterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(20), heightDimension: .estimated(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(10),  heightDimension: .estimated(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        section.orthogonalScrollingBehavior = .continuous
    
        return section
    }
    
    final func createProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .uniformAcrossSiblings(estimate: 300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .uniformAcrossSiblings(estimate: 300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 12, trailing: 4)
        return section
    }
}

//MARK: - ProductListViewModelDelegate
extension ProductListViewController: ProductListViewModelDelegate {
    func reloadCollectionView() {
        applySnapshot()
    }
}
