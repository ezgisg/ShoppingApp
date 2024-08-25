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
final class CategoriesViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    //MARK: - Private Variables
    ///Creating data sources with different models to try applying diffable data source with different models
    private var dataSource: UICollectionViewDiffableDataSource<CategoriesScreenSectionType, AnyHashable>?
    private var searchController: UISearchController?
    
    // MARK: - Module Components
    private var viewModel: CategoriesViewModel
    private var coordinator: CategoriesCoordinator
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        showLoadingView()
        viewModel.fetchCategories()
        setups()
    }
    
     // MARK: - Module init
    init(
        coordinator: CategoriesCoordinator,
        viewModel: CategoriesViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func dismissKeyboard() {
        guard let searchBar = searchController?.searchBar else { return }
        searchBar.resignFirstResponder()
    }
}

//MARK: Setups
private extension CategoriesViewController {
    final func setupUI() {
        collectionView.backgroundColor = .white
        containerView.backgroundColor = .tabbarBackgroundColor
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.tabbarBackgroundColor
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedColor]
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }
    
    final func setupCollectionView() {
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        collectionView.delegate = self
        configureDatasource()
        collectionView.register(nibWithCellClass: CategoryBannerCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CategoryCell.self, at: Bundle.module)
        collectionView.registerReusableView(nibWithViewClass: FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, at: Bundle.module)
        configureDatasource()
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func setups() {
        setupUI()
        setupCollectionView()
        setupSearchButton()
        setupKeyboardObservers()
    }
}

//MARK: UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.filteredCategories[indexPath.row]
        coordinator.routeToProductList(with: [category])
    }
}

// MARK: - Diffable Data Source
private extension CategoriesViewController {
    final func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, categories in
            guard let self,
                  let sectionType = CategoriesScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch sectionType {
            case .banner:
                let cell = collectionView.dequeueReusableCell(withClass: CategoryBannerCell.self, for: indexPath)
                if let imagePath = viewModel.banners[indexPath.row].imagePath {
                    cell.configureWith(imagePath: imagePath )
                }
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(withClass: CategoryCell.self, for: indexPath)
                let data = viewModel.filteredCategories[indexPath.row]
                cell.configureWith(imagePath: data.imagePath ?? "", text: data.value ?? "")
                return cell
            }
        })
        applySnapshot()
        configureSupplementaryViewsDataSource()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CategoriesScreenSectionType, AnyHashable>()
        for section in CategoriesScreenSectionType.allCases {
            snapshot.appendSections([section]) }
        
        snapshot.appendItems(viewModel.banners, toSection: .banner)
        snapshot.appendItems(viewModel.filteredCategories, toSection: .categories)
        
        dataSource?.apply(snapshot)
    }
    
    final func configureSupplementaryViewsDataSource() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionType = CategoriesScreenSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: FooterView.self, for: indexPath)
            switch sectionType {
            case .banner:
                return UICollectionReusableView()
            case .categories:
                footerView.configureWith(text: L10nGeneric.allCategories.localized()) {  [weak self] in
                    guard let self else { return }
                    coordinator.routeToProductList(with: viewModel.categories)
                }
                return footerView
            }
        }
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
       
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),  heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        return section
    }
    
    final func createCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10)
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]

        return section
    }
}

// MARK: - UISearchControllerDelegate
extension CategoriesViewController: UISearchControllerDelegate {
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = .tabbarSelectedColor
    }
    
    @objc private func searchButtonTapped() {
        guard navigationItem.searchController == nil else {
            navigationItem.searchController = nil
            return }
        searchController = UISearchController(searchResultsController: nil)
        guard let searchController else { return }
        let searchTextField = searchController.searchBar.searchTextField
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10nGeneric.searchCategories.localized()
        searchController.searchBar.tintColor = .tabbarSelectedColor
        
        searchTextField.overrideUserInterfaceStyle = .light
        searchTextField.backgroundColor = .white
        searchTextField.tintColor = .black
        searchTextField.leftView?.tintColor = .black
        
        navigationItem.searchController = searchController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

//MARK: UISearchResultsUpdating
extension CategoriesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        viewModel.searchInCategories(searchText: searchText ?? "")
    }
}

//MARK: CategoriesViewModelDelegate
extension CategoriesViewController: CategoriesViewModelDelegate {
    func reloadCollectionView() {
        hideLoadingView()
        applySnapshot()
    }
}


