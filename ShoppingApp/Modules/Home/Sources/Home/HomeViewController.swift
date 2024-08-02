//
//  HomeViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - Enums
enum HomeScreenSectionType: Int, CaseIterable {
    case campaign = 0
    case banner = 1
    case categoryBanner = 2
}

// MARK: - HomeViewController
public class HomeViewController: BaseViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Module Components
    private var viewModel = HomeViewModel()
    
    var ImageArray : [UIImage] = [.browseImage, .checkoutImage]

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        viewModel.delegate = self
        let currentLanguage = Localize.currentLanguage().uppercased()
        viewModel.loadBannerData(for: currentLanguage)
        setupKeyboardObservers()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
     // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func getBannerData(bannerData: BannerData) {
        print(bannerData)
    }
}


extension HomeViewController {
    final func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: BannerCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CampaignCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeScreenSectionType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeScreenSectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .campaign:
            return ImageArray.count
        case .banner:
            return ImageArray.count
        case .categoryBanner:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch sectionType {
        case .campaign:
            let cell = collectionView.dequeueReusableCell(withClass: BannerCell.self, for: indexPath)
            cell.configureWith(image: ImageArray[indexPath.row])
            return cell
        case .banner:
            let cell = collectionView.dequeueReusableCell(withClass: BannerCell.self, for: indexPath)
            cell.configureWith(image: ImageArray[indexPath.row])
            return cell
        case .categoryBanner:
            let cell = collectionView.dequeueReusableCell(with: BannerCell.self , for: indexPath)
            return cell
        }
    }
}

// MARK: - Compositional Layout
extension HomeViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let sectionType = HomeScreenSectionType(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .campaign:
                return self.createCampaignSection()
            case .banner:
                return self.createBannerSection()
            case .categoryBanner:
                return self.createCategoryBannerSection()
            }
        }
    }
    
    private func createCampaignSection() -> NSCollectionLayoutSection {
        // Create item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Create group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // Create item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Create group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func createCategoryBannerSection() -> NSCollectionLayoutSection {
        // Create item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Create group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return section
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
}
