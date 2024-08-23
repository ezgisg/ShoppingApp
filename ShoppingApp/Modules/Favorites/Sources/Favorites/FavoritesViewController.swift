//
//  FavoritesViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 20.08.2024.
//

import AppResources
import AppManagers
import Base
import Components
import UIKit
import ProductList


//MARK: - FavoritesViewController
public class FavoritesViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyView: EmptyView!
    
    //MARK: - Variables
    var favorites: [ProductResponseElement]?
    
    //MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setups()
 
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        fetchFavorites()
    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
}

//MARK: - Setups
private extension FavoritesViewController {
    final func setups() {
        setupColors()
        configureCollectionView()
        navigationItem.title = "Favorilerim"
        
        //TODO:localizable vs..
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.tabbarBackgroundColor, renderingMode: .alwaysOriginal)
        emptyView.configure(with: .detailed(image: image ?? .browseImage, title: "Favorilerinde Ürün Yok", subtitle: "Henüz favorilerine ürün eklemedin. Ürünlerimizi keşfetmek ister misin? Başlamak için hemen tıkla!", buttonTitle: "Keşfet", buttonColor: .tabbarBackgroundColor, buttonAction: { [weak self] in
            guard let self,
                  let tabBarController = self.tabBarController
            else { return }
            tabBarController.selectedIndex = 1
        }))
    }
    
    final func setupColors() {
        containerView.backgroundColor = .tabbarBackgroundColor
        collectionView.backgroundColor = .white
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.tabbarBackgroundColor
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedColor]
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }
    
    final func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: ProductCell.self, at: Components.bundle)
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.showsVerticalScrollIndicator = false
    }
}

//MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productID = favorites?[indexPath.row].id else { return }
        let detailVC = ProductDetailViewController(productID: productID, products: [])
        detailVC.onScreenDismiss = {  [weak self] in
            guard let self else { return }
            fetchFavorites()
        }
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .crossDissolve
        present(detailVC, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProductCell.self, for: indexPath)
        if let data = favorites?[safe: indexPath.row] {
            cell.configure(withId: data.id, withRating: nil, ratingCount: nil, categoryName: data.category, productName: data.title, price: data.price, imagePath: data.image)
            cell.onCartTapped = { [weak self] in
                                    guard let self else { return }
                handleCartTap(for: data)
            }
            cell.onFavoriteTapped = { [weak self] in
                guard let self else { return }
                handleFavoriteTap(for: data)
            }
        }
        return cell
    }
}

//MARK: - Compositional Layout
private extension FavoritesViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createProductSection()
        }
    }
    
    final func createProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .uniformAcrossSiblings(estimate: 100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 24, trailing: 8)
        return section
    }
}

//MARK: - Helpers
private extension FavoritesViewController {
    final func handleFavoriteTap(for product: ProductResponseElement?) {
        guard let product else { return }

        let oldFavorites = favorites
        FavoritesManager.shared.toggleFavorite(product: product)
        favorites = FavoritesManager.shared.getFavorites()
        
        collectionView.performBatchUpdates({
            guard let oldIndex = oldFavorites?.firstIndex(where: { $0.id == product.id }) else { return }
            collectionView.deleteItems(at: [IndexPath(row: oldIndex, section: 0)])
        }, completion: nil)
        
        emptyView.isHidden = (favorites?.count ?? 0) > 0
    }

    final func handleCartTap(for product: ProductResponseElement?) {
        guard let product else { return }
        let detailBottomVC = DetailBottomViewController(product: product)
        detailBottomVC.modalPresentationStyle = .overFullScreen
        detailBottomVC.modalTransitionStyle = .crossDissolve
        present(detailBottomVC, animated: true, completion: nil)
    }

    final func fetchFavorites() {
        favorites = FavoritesManager.shared.getFavorites()
        emptyView.isHidden = (favorites?.count ?? 0) > 0 ? true : false
        collectionView.reloadData()
    }
}

