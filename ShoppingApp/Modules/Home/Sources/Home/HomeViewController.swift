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
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - Module Components
    private var viewModel = HomeViewModel()
    
    
    private var bannerData : BannerData? = nil
    
    //TODO: titleArray vm e alınıp localizable dan eklenecek
    var ImageArray : [UIImage] = [.browseImage, .checkoutImage, .welcomeImage, .registerImage]
    var titleArray: [String] = ["Büyük İndirime Hazır Olun","%50'ye varan indirimler","Son Kalanları Kaçırma","Hemen Alışverişe Başla"]
    var currentIndex = 0
    var timer: Timer?
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setups()
        viewModel.delegate = self
    
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
    
    deinit {
        
        timer?.invalidate()
    }

}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func getBannerData(bannerData: BannerData) {
        self.bannerData = bannerData
        collectionView.reloadData()
    }
}


extension HomeViewController {
    final func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: BannerCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CampaignCell.self, at: Bundle.module)
        collectionView.registerReusableView(nibWithViewClass: PageControllerReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeScreenSectionType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeScreenSectionType(rawValue: section),
              let data = bannerData
        else { return 0 }
        switch sectionType {
        case .campaign:
            return data.elements?.filter { $0.type == "campaign" }.first?.items?.count ?? 0
        case .banner:
            return data.elements?.filter { $0.type == "banner" }.first?.items?.count ?? 0
        case .categoryBanner:
            return ImageArray.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch sectionType {
        case .campaign:
            let cell = collectionView.dequeueReusableCell(withClass: CampaignCell.self, for: indexPath)
            let campaignData = bannerData?.elements?.filter { $0.type == "campaign" }.first?.items
            cell.configureWith(
                imagePath: campaignData?[safe: indexPath.row]?.image ?? "",
                text:   campaignData?[safe: indexPath.row]?.name ?? ""
            )
            return cell
        case .banner:
            let cell = collectionView.dequeueReusableCell(withClass: BannerCell.self, for: indexPath)
            let bannerData = bannerData?.elements?.filter { $0.type == "banner" }.first?.items
            cell.configureWithImagePath(imagePath: bannerData?[safe: indexPath.row]?.image ?? "", cornerRadius: 20)
            return cell
        case .categoryBanner:
            let cell = collectionView.dequeueReusableCell(withClass: BannerCell.self, for: indexPath)
            cell.configureWith(image: ImageArray[indexPath.row])
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: PageControllerReusableView.self, for: indexPath)
            if indexPath.section == HomeScreenSectionType.banner.rawValue {
                headerView.configureNumberOfPage(with: ImageArray.count)
            }
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - Compositional Layout
extension HomeViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
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
        
        return layout
    }
    
    private func createCampaignSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(104),
            heightDimension: .uniformAcrossSiblings(estimate: 150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(104),
            heightDimension: .uniformAcrossSiblings(estimate: 150)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
   
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        footer.extendsBoundary = false

        section.boundarySupplementaryItems = [footer]
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
            guard let self else { return }
            let page = round(offset.x / self.view.bounds.width)
        
            if let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: HomeScreenSectionType.banner.rawValue)) as? PageControllerReusableView {
                headerView.configureCurrentPage(with: Int(page))
            }
        }
    
        return section
    }
    

    
    private func createCategoryBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}


extension HomeViewController: UICollectionViewDelegate {
 
}

//MARK: Setups
extension HomeViewController {
    final func setupUI() {
        collectionView.backgroundColor = .white
        backgroundView.backgroundColor = .tabbarBackgroundColor
        topLabel.backgroundColor = .middleButtonColor
        topLabel.textColor = .white
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 10
        profileImage.image = .profile
    }
    
    final func fetchInitialData() {
        let currentLanguage = Localize.currentLanguage().uppercased()
        viewModel.loadBannerData(for: currentLanguage)
    }
    
    final func setups() {
        viewModel.delegate = self
        fetchInitialData()
        setupCollectionView()
        setupUI()
        setupKeyboardObservers()
        startTextRotation()
    }
    
    func startTextRotation() {
        topLabel.text = titleArray[currentIndex]
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLabelText), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabelText() {
        UIView.transition(with: topLabel,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {  [weak self] in
            guard let self else { return }
            currentIndex = (currentIndex + 1) % titleArray.count
            topLabel.text = titleArray[currentIndex]
        }
                          ,
                          completion: nil)
      }

}
