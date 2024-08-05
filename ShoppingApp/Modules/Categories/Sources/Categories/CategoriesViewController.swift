//
//  CategoriesViewController.swift
//
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import AppResources
import Base
import UIKit


// MARK: - Enums
enum CategoriesScreenSectionType: Int, CaseIterable, Hashable {
    case banner = 0
    case categories = 1
    
    var stringValue: String? {
         switch self {
         case .banner:
             return "banner"
         case .categories:
             return "categories"
         }
     }
}

// MARK: - CategoriesViewContoller
public class CategoriesViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    //MARK: - Private Variables
    ///Creating data sources with different models to try applying diffable data source with different models
    private var categories: [CategoryResponseElement]?
    private var banners: [BannerElement]?
    private var dataSource: UICollectionViewDiffableDataSource<CategoriesScreenSectionType, AnyHashable>?
    
    // MARK: - Module Components
    private var viewModel = CategoriesViewModel()
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchCategories()
        setupUI()
        setupCollectionView()
    }
    
     // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: Setups
extension CategoriesViewController {
    final func setupUI() {
        collectionView.backgroundColor = .white
        containerView.backgroundColor = .tabbarBackgroundColor
    }
    
    final func setupCollectionView() {
        collectionView.delegate = self
        configureDatasource()
        collectionView.register(nibWithCellClass: CategoryBannerCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CategoryCell.self, at: Bundle.module)
        configureDatasource()
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

//MARK: UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    
}

//TODO: resimler ve datalar değişecek
// MARK: - Diffable Data Source
private extension CategoriesViewController {
    final func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, categories in
            guard let self,
                  let sectionType = CategoriesScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch sectionType {
            case .banner:
                let cell = collectionView.dequeueReusableCell(withClass: CategoryBannerCell.self, for: indexPath)
                if let imagePath = banners?[indexPath.row].imagePath {
                    cell.configureWith(imagePath: imagePath )
                }
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(withClass: CategoryCell.self, for: indexPath)
                let data = self.categories?[indexPath.row]
                cell.configureWith(imagePath: data?.imagePath ?? "", text: data?.value ?? "")
                return cell
            }
        })
        applySnapshot()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CategoriesScreenSectionType, AnyHashable>()
        for section in CategoriesScreenSectionType.allCases {
            snapshot.appendSections([section]) }
        if let banners {
            snapshot.appendItems(banners, toSection: .banner)
        }
        if let categories {
            snapshot.appendItems(categories, toSection: .categories)
        }
        dataSource?.apply(snapshot)
    }
}


// MARK: - Compositional Layout
private extension CategoriesViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = CategoriesScreenSectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .banner:
                return createBannerSection()
            case .categories:
                return createCategoriesSection()
            }
        }
    }
    
    final func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),  heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        return section
    }
    
    final func createCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return section
    }
}

//MARK: CategoriesViewModelDelegate
extension CategoriesViewController: CategoriesViewModelDelegate {
    func getCategories(categories: [CategoryResponseElement]) {
        self.categories = categories
        banners = viewModel.banners
        applySnapshot()
    }
}


