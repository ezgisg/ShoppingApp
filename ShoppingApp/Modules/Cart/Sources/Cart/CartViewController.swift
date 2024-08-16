//
//  CartViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import AppManagers
import Base
import UIKit
import ProductList

// MARK: - Enums
enum CartScreenSectionType: Int, CaseIterable {
    case top = 0
    case cart = 1
    case coupon = 2
    case similarProducts = 3
    
    var stringValue: String? {
        switch self {
        case .top:
            "top"
        case .cart:
            "cart"
        case .coupon:
            "coupon"
        case .similarProducts:
            "similarProducts"
        }
     }
}

public class CartViewController: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var paymentButton: UIButton!
    
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var detailStack: UIStackView!
    @IBOutlet weak var orderSummaryLabelOfDetailStack: UILabel!
    @IBOutlet weak var detailImageOfDetailStack: UIImageView!
    @IBOutlet weak var sumLabelOfDetailStack: UILabel!
    @IBOutlet weak var sumCountLabelOfDetailStack: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountCountLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalCountLabel: UILabel!
    @IBOutlet weak var cargoFeeLabel: UILabel!
    @IBOutlet weak var cargoFeeCountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var miniDetailStack: UIStackView!
    @IBOutlet weak var orderSummaryLabelOfMiniDetailStack: UILabel!
    @IBOutlet weak var detailImageOfMiniDetailStack: UIImageView!
    
    @IBOutlet weak var sumStack: UIStackView!
    @IBOutlet weak var sumLabelofSumStack: UILabel!
    @IBOutlet weak var sumLabelCountofSumStack: UILabel!
    
    @IBOutlet weak var sumStackWithDiscount: UIStackView!
    
    @IBOutlet weak var InnerTotalDiscountStack: UIStackView!
    @IBOutlet weak var discountStackBackView: UIView!
    @IBOutlet weak var totalDiscountLabel: UILabel!
    @IBOutlet weak var totalDiscountCountLabel: UILabel!
    @IBOutlet weak var sumLabelofSumStackWithDiscount: UILabel!
    @IBOutlet weak var sumLabelCountofSumStackWithDiscount: UILabel!
    
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Variables
    private var dataSource: UICollectionViewDiffableDataSource<CartScreenSectionType, AnyHashable>?
    
    // MARK: - Module Components
    public var viewModel = CartViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        ///not fetching data here because when something change in cart observer listen changes to reload collectionView
        viewModel.delegate = self
        setups()
    }
    
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}

//MARK: -  Setups
private extension CartViewController {
    final func setups() {
        setupTexts()
        setupTextsColorFont()
        setupBackgrounds()
        setupInitialHiddenStatus()
        setupGestures()
        setupCollectionView()
    }
    
    //TODO: Localizable ile başlıklar vs doldurulacak
    final func setupTexts() {
        setTotalPrice()
    }
    
    final func setupTextsColorFont() {
        paymentButton.titleLabel?.textColor = .buttonTextColor
        orderSummaryLabelOfDetailStack.font = .boldSystemFont(ofSize: 22)
        orderSummaryLabelOfDetailStack.textColor = .tabbarBackgroundColor

        sumLabelOfDetailStack.textColor = .darkGray
        sumLabelOfDetailStack.font = .boldSystemFont(ofSize: 16)
        sumCountLabelOfDetailStack.textColor = .lightGray
        sumCountLabelOfDetailStack.font = .systemFont(ofSize: 16)
        discountLabel.textColor = .darkGray
        discountLabel.font = .boldSystemFont(ofSize: 16)
        discountCountLabel.textColor = .lightGray
        discountCountLabel.font = .systemFont(ofSize: 16)
        subTotalLabel.textColor = .darkGray
        subTotalLabel.font = .boldSystemFont(ofSize: 16)
        subTotalCountLabel.textColor = .lightGray
        subTotalCountLabel.font = .systemFont(ofSize: 16)
        cargoFeeLabel.textColor = .darkGray
        cargoFeeLabel.font = .boldSystemFont(ofSize: 16)
        cargoFeeCountLabel.textColor = .lightGray
        cargoFeeCountLabel.font = .systemFont(ofSize: 16)
        infoLabel.textColor =  .lightGray
        infoLabel.font = .italicSystemFont(ofSize: 14)

        orderSummaryLabelOfMiniDetailStack.font = .boldSystemFont(ofSize: 22)
        orderSummaryLabelOfMiniDetailStack.textColor = .tabbarBackgroundColor

        sumLabelofSumStack.textColor = .darkGray
        sumLabelofSumStack.font = .boldSystemFont(ofSize: 22)
        sumLabelCountofSumStack.textColor = .tabbarBackgroundColor
        sumLabelCountofSumStack.font = .boldSystemFont(ofSize: 22)
        
        totalDiscountLabel.textColor = .darkGray
        totalDiscountLabel.font = .boldSystemFont(ofSize: 18)
        totalDiscountCountLabel.textColor = .middleButtonColor
        totalDiscountCountLabel.font = .boldSystemFont(ofSize: 20)
        sumLabelofSumStackWithDiscount.textColor = .darkGray
        sumLabelofSumStackWithDiscount.font = .boldSystemFont(ofSize: 18)
        sumLabelCountofSumStackWithDiscount.textColor = .tabbarBackgroundColor
        sumLabelCountofSumStackWithDiscount.font = .boldSystemFont(ofSize: 18)
        
    }
    
    final func setupBackgrounds() {
        mainView.layer.shadowOffset = CGSize(width: 0, height: -2)
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
    
        buttonBackgroundView.backgroundColor = .white
        topBackgroundView.backgroundColor = .white
        collectionView.backgroundColor = .lightDividerColor
        paymentButton.backgroundColor = .tabbarBackgroundColor
        paymentButton.layer.cornerRadius = 8
        discountStackBackView.backgroundColor = .lightButtonColor
        discountStackBackView.layer.cornerRadius = 4
        
        detailImageOfDetailStack.image = .detailCategory
        detailImageOfMiniDetailStack.image = .detailCategory
    }
    
    final func setupInitialHiddenStatus() {
        detailStack.isHidden = true
        sumStackWithDiscount.isHidden = true
    }
    
    final func setupGestures() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(toggleStacks))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(toggleStacks))

        detailImageOfDetailStack.isUserInteractionEnabled = true
        detailImageOfDetailStack.addGestureRecognizer(tapGesture1)
        
        detailImageOfMiniDetailStack.isUserInteractionEnabled = true
        detailImageOfMiniDetailStack.addGestureRecognizer(tapGesture2)

    }

    @objc func toggleStacks() {
        let shouldShowDetailStackWithDiscount = detailStack.isHidden
        detailStack.isHidden = !shouldShowDetailStackWithDiscount
        miniDetailStack.isHidden = shouldShowDetailStackWithDiscount
    }
    
    final func setupCollectionView() {
        collectionView.delegate = self
        configureDatasource()
        collectionView.register(nibWithCellClass: CartControlCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartProductCollectionViewCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartBottomProductCollectionViewCell.self, at: Bundle.module)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
}

extension CartViewController: CartViewModelDelegate {
    func reloadData() {
        applySnapshot()
        collectionView.reloadData()
    }
    
    func hideLoading() {
        hideLoadingView()
    }
    
    func showLoading() {
        showLoadingView()
    }
    
    func setTotalPrice() {
        let totalPrice = String(format: "%.2f",  viewModel.totalPrice ?? 0)
        sumLabelCountofSumStack.text = "\(totalPrice) $"
        sumCountLabelOfDetailStack.text = "\(totalPrice) $"
    }
}

extension CartViewController: UICollectionViewDelegate {
    
}

// MARK: - Compositional Layout
extension CartViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = CartScreenSectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .top:
                return topSection()
            case .cart:
                return cartSection()
            case .coupon:
                return cartSection()
            case .similarProducts:
                return similarSection()
            }
        }
    }
    
    final func topSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(136))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(136))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        return section
    }
    
    final func cartSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(136))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(136))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 12, trailing: 8)
        return section
    }
    
    final func similarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(112), heightDimension: .absolute(225))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(112), heightDimension: .absolute(225))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        if viewModel.similarProducts.count > 0 {
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
}

//MARK: - Diffable Data Source
extension CartViewController {
    final func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self,
                  let sectionType = CartScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch sectionType {
            case .top:
                let cell = collectionView.dequeueReusableCell(withClass: CartControlCell.self, for: indexPath)
                let selectedItemCount = CartManager.shared.selectionOfProducts.filter { $0.isSelected == true }.count
                let isSelectAllActive = selectedItemCount == CartManager.shared.selectionOfProducts.count
                cell.onSelectAllTapped = {
                    CartManager.shared.updateAllProductsSelection(to: !isSelectAllActive)
                }
                cell.onDeleteAllTapped = {  [weak self] in
                    guard let self else { return }
                    guard selectedItemCount > 0 else { return }
                    showLoadingView()
                    CartManager.shared.removeAllSelectedFromCart()
                }
                cell.configureWith(selectedItemCount: selectedItemCount, isSelectAllActive: isSelectAllActive)
                return cell
            case .cart:
                let cell = collectionView.dequeueReusableCell(withClass: CartProductCollectionViewCell.self, for: indexPath)
                let cartItem = viewModel.products[indexPath.row]
                guard let id = cartItem.id, let size = cartItem.size else { return cell }
                let isSelected = viewModel.selectionOfProducts
                    .first(where: { $0.id == id && $0.size == size })?
                    .isSelected
                //TODO: discount kupon section ı hazır olduğunda gönderilecek, discount oranına çevrilebilir
                cell.configureWith(product: cartItem, discountedPrice: nil, isSelected: isSelected)
                cell.onSelectionTapped = {
                    CartManager.shared.updateProductSelection(productId: id, size: size)
                }
                cell.onMinusTapped = {  [weak self] in
                    guard let self else { return }
                    showLoadingView()
                    CartManager.shared.removeFromCart(productId: id, size: size)
                
                }
                cell.onPlusTapped = {  [weak self] in
                    guard let self else { return }
                    showLoadingView()
                    CartManager.shared.addToCart(productId: id, size: size)
                }
                return cell
            case .coupon:
                return UICollectionViewCell()
            case .similarProducts:
                let cell = collectionView.dequeueReusableCell(withClass: CartBottomProductCollectionViewCell.self, for: indexPath)
                let product = viewModel.similarProducts[indexPath.row]
                cell.configureWith(product: product)
                cell.onAddToCartTapped = {  [weak self] in
                    guard let self else { return }
                    let detailBottomVC = DetailBottomViewController(product: product)
                    detailBottomVC.modalPresentationStyle = .overFullScreen
                    detailBottomVC.modalTransitionStyle = .crossDissolve
                    present(detailBottomVC, animated: true, completion: nil)
                }
                return cell
            }
        })
        configureSupplementaryViewsDataSource()
        applySnapshot()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CartScreenSectionType, AnyHashable>()
        for section in CartScreenSectionType.allCases {
            snapshot.appendSections([section])
        }
    
        if viewModel.products.count > 0 {
            snapshot.appendItems(["topSection"], toSection: .top)
        }
        snapshot.appendItems(viewModel.products, toSection: .cart)
        snapshot.appendItems(viewModel.similarProducts, toSection: .similarProducts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    final func configureSupplementaryViewsDataSource() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionType = CartScreenSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: SectionHeader.self, for: indexPath)
            switch sectionType {
            case .similarProducts:
                headerView.configure(with: "Benzer Ürünler", color: .gray, leading: 8)
                return headerView
            default:
                return UICollectionReusableView()
            }
        }
        
    }
}
