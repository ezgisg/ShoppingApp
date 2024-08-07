//
//  ProductListViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

//TODO: Data çekilen her yere loading koyalım
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
    @IBOutlet weak var selectedFilterImage: UIImageView!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var sortingImage: UIImageView!
    @IBOutlet private weak var sortingLabel: UILabel!
    @IBOutlet weak var selectedSortingImage: UIImageView!
    @IBOutlet private weak var bigLayoutImage: UIImageView!
    @IBOutlet private weak var smallLayoutImage: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterAreaStackView: UIStackView!
    
    @IBOutlet weak var filterTopView: UIView!
    @IBOutlet weak var sortingTopView: UIView!
    
    // MARK: - Variables
    var category = String()
    var categories = [CategoryResponseElement]()
    var sortingOption: SortingOption = .none {
        didSet {
            if sortingOption == .none {
                selectedSortingImage.isHidden = true
            } else {
                selectedSortingImage.isHidden = false
            }
        }
    }
    
    // MARK: - Private Variables
    private var dataSource: UICollectionViewDiffableDataSource<ProductListScreenSectionType, AnyHashable>?
    private var itemCount: Double = 2 {
        didSet {
            let layout = createCompositionalLayout()
            collectionView.setCollectionViewLayout(layout, animated: true)
            ///using only set CollectionViewLayout animates causes animation in filter section unnecessarily. With applysnapshot it affects only changed section
            applySnapshot()
        }
    }
    private var selectedCategories = Set<CategoryResponseElement>() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                viewModel.fetchProductsWithSelectedCategories(categories: selectedCategories)
                controlFilterStatus()
            }
        }
    }
    
    // MARK: - Module Components
    private var viewModel = ProductListViewModel()
 
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        viewModel.delegate = self
        viewModel.fetchProducts(categoryName: category)
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
        
        navigationController?.navigationBar.tintColor = .tabbarSelectedColor
        selectedFilterImage.tintColor = .lightButtonColor?.withAlphaComponent(1)
        selectedSortingImage.tintColor = .lightButtonColor?.withAlphaComponent(1)
        
        sortingImage.image = .sorting
        smallLayoutImage.image = .smallLayout
        bigLayoutImage.image = .bigLayout
        filterImage.image = .filter
        selectedFilterImage.image = .systemCircleImage
        selectedSortingImage.image = .systemCircleImage
        
        selectedFilterImage.isHidden = true
        selectedSortingImage.isHidden = true

        filterLabel.text = L10nGeneric.filter.localized()
        filterLabel.textColor = .darkGray
        sortingLabel.text = L10nGeneric.sorting.localized()
        sortingLabel.textColor = .darkGray
        
        bigLayoutImage.layer.opacity = 0.3
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
        collectionView.delegate = self
        configureDatasource()
        collectionView.register(nibWithCellClass: ProductCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: FilterCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func setupGestures() {
        let bigLayoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(bigLayoutTapped))
        bigLayoutImage.addGestureRecognizer(bigLayoutTapGesture)
        bigLayoutImage.isUserInteractionEnabled = true
        
        let smallLayoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(smallLayoutTapped))
        smallLayoutImage.addGestureRecognizer(smallLayoutTapGesture)
        smallLayoutImage.isUserInteractionEnabled = true
        
        let sortingTapGesture = UITapGestureRecognizer(target: self, action: #selector(sortingTapped))
        sortingTopView.addGestureRecognizer(sortingTapGesture)
        sortingTopView.isUserInteractionEnabled = true
        
        let filterTapGesture = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        filterTopView.addGestureRecognizer(filterTapGesture)
        filterTopView.isUserInteractionEnabled = true
    }
    
    @objc final func bigLayoutTapped() {
        guard itemCount != 1 else { return }
        itemCount = 1
        bigLayoutImage.layer.opacity = 1
        smallLayoutImage.layer.opacity = 0.3
    }
    
    @objc final func smallLayoutTapped() {
        guard itemCount != 2 else { return }
        itemCount = 2
        bigLayoutImage.layer.opacity = 0.3
        smallLayoutImage.layer.opacity = 1
    }
    
    final func setups() {
        setupUI()
        setupCollectionView()
        setupGestures()
    }
    

    @objc private func sortingTapped() {
        let bottomSheetVC = BottomSheetViewController(selectedOption: sortingOption)
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        bottomSheetVC.applySorting = { [weak self] selectedOption in
            guard let self else { return }
            applySorting(option: selectedOption)
            sortingOption = selectedOption
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    //TODO: Düzenlenecek
    @objc private func filterTapped() {
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(filterVC, animated: true)
    }
    

    private func applySorting(option: SortingOption) {
        switch option {
        case .highestPrice:
            viewModel.filteredProducts.sort { $0.price ?? 0 > $1.price ?? 0 }
        case .lowestPrice:
            viewModel.filteredProducts.sort { $0.price ?? 0 < $1.price ?? 0}
        case .none:
            viewModel.filteredProducts.sort { $0.id ?? 0 < $1.id ?? 0}
        }
        applySnapshot()
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
                let category = categories[indexPath.row]
                cell.configureWith(text: category.value ?? "")
                cell.isSelectedCell = selectedCategories.contains(category)
                return cell
            case .products:
                let cell = collectionView.dequeueReusableCell(withClass: ProductCell.self, for: indexPath)
                if let data = viewModel.filteredProducts[safe: indexPath.row] {
                    cell.configure(withRating: data.rating?.rate , ratingCount: data.rating?.count, categoryName: data.category, productName: data.title, price: data.price, imagePath: data.image)
                }
                return cell
            }
        })
        applySnapshot()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListScreenSectionType, AnyHashable>()
        for section in ProductListScreenSectionType.allCases {
            snapshot.appendSections([section])
        }
    
        snapshot.appendItems(categories, toSection: .filter)
        snapshot.appendItems(viewModel.filteredProducts, toSection: .products)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(10),  heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        section.orthogonalScrollingBehavior = .continuous
        
        
        return section
    }
    
    final func createProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/(itemCount)), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 12, trailing: 4)
        return section
    }

}

//MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
 
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = ProductListScreenSectionType(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .filter:
            let selectedCategory = categories[indexPath.row]
            if selectedCategories.contains(selectedCategory) {
                selectedCategories.remove(selectedCategory)
            } else {
                selectedCategories.insert(selectedCategory)
            }
            
            collectionView.reloadData()

        case .products:
            break
        }
    }
    
}

//MARK: - Helpers
private extension ProductListViewController {
    final func controlFilterStatus() {
        let isFiltering = selectedCategories.count != 0
        selectedFilterImage.isHidden = !isFiltering
        if isFiltering {
            filterLabel.text = "\(L10nGeneric.filter.localized()) (\(selectedCategories.count))"
        } else {
            filterLabel.text = L10nGeneric.filter.localized()
        }
    }
}

//MARK: - ProductListViewModelDelegate
extension ProductListViewController: ProductListViewModelDelegate {
    func reloadCollectionView() {
        applySnapshot()
    }
}

