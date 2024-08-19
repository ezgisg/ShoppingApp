//
//  CampaignsViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 19.08.2024.
//

import AppResources
import UIKit

public class CampaignsViewController: UIViewController {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Module Components
    private var viewModel = CampaignsViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setups()
        fetchInitialData()
    }
    
    
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    final func fetchInitialData() {
        let currentLanguage = Localize.currentLanguage().uppercased()
        viewModel.loadCampaignData(for: currentLanguage)
    }
    

}

private extension CampaignsViewController {
    final func setups() {
        setupCollectionView()
        setColors()
        
        navigationItem.title = "Kampanyalar"
       
    }
    
    final func setColors() {
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: CampaignCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

extension CampaignsViewController: CampaignsViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}

extension CampaignsViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.campaignData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CampaignCell.self, for: indexPath)
        guard let data = viewModel.campaignData?[indexPath.row] else {return cell}
        cell.configureWith(data: data)
        return cell
    }
}

extension CampaignsViewController : UICollectionViewDelegate {
    
}

// MARK: - Compositional Layout
private extension CampaignsViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            self.createCampaignSection()
        }
    }
    
    final func createCampaignSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(224))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
          
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),  heightDimension: .absolute(224))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 0, trailing: 12)
        return section
    }
    
}
