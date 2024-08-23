//
//  CartViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import AppManagers
import Base
import Components
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

// MARK: - CartViewController
public class CartViewController: BaseViewController {
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var buttonBackgroundView: UIView!
    @IBOutlet private weak var paymentButton: UIButton!
  
    @IBOutlet private weak var mainStack: UIStackView!

    @IBOutlet private weak var detailStack: UIStackView!
    @IBOutlet private weak var orderSummaryLabelOfDetailStack: UILabel!
    @IBOutlet private weak var detailImageOfDetailStack: UIImageView!
    @IBOutlet private weak var sumLabelOfDetailStack: UILabel!
    @IBOutlet private weak var sumCountLabelOfDetailStack: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var discountCountLabel: UILabel!
    @IBOutlet private weak var subTotalLabel: UILabel!
    @IBOutlet private weak var subTotalCountLabel: UILabel!
    @IBOutlet private weak var cargoFeeLabel: UILabel!
    @IBOutlet private weak var cargoFeeCountLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
  
    @IBOutlet private weak var miniDetailStack: UIStackView!
    @IBOutlet private weak var orderSummaryLabelOfMiniDetailStack: UILabel!
    @IBOutlet private weak var detailImageOfMiniDetailStack: UIImageView!

    @IBOutlet private weak var sumStack: UIStackView!
    @IBOutlet private weak var sumLabelofSumStack: UILabel!
    @IBOutlet private weak var sumLabelCountofSumStack: UILabel!

    @IBOutlet private weak var sumStackWithDiscount: UIStackView!

    @IBOutlet private weak var InnerTotalDiscountStack: UIStackView!
    @IBOutlet private weak var discountStackBackView: UIView!
    @IBOutlet private weak var totalDiscountLabel: UILabel!
    @IBOutlet private weak var totalDiscountCountLabel: UILabel!
    @IBOutlet private weak var sumLabelofSumStackWithDiscount: UILabel!
    @IBOutlet private weak var sumLabelCountofSumStackWithDiscount: UILabel!

    @IBOutlet private weak var topBackgroundView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var emptyView: EmptyView!
    
    // MARK: - Private Variables
    private var dataSource: UICollectionViewDiffableDataSource<CartScreenSectionType, AnyHashable>?
    private var couponCell: CouponCell?

    // MARK: - Module Components
    public var viewModel = CartViewModel()

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        ///not fetching data here because when something change in cart observer listen changes to reload collectionView
        viewModel.delegate = self
        setups()
        setupKeyboardObservers(scrollView: collectionView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controlEmptyViewHiddenStatus()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    

    final func setupTexts() {
        setTotalPrice()
        paymentButton.setTitle("ÖDEME ADIMINA GEÇ", for: .normal)
        //TODO: xib ler de localizable ile alınacak
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
        topBackgroundView.backgroundColor = .tabbarBackgroundColor
        collectionView.backgroundColor = .lightDividerColor
        paymentButton.backgroundColor = .tabbarBackgroundColor
        paymentButton.layer.cornerRadius = 8
        discountStackBackView.backgroundColor = .lightButtonColor
        discountStackBackView.layer.cornerRadius = 4
        
        detailImageOfDetailStack.image = .detailCategory
        detailImageOfMiniDetailStack.image = .detailCategory
        
        emptyView.configure(
            with: .detailed(image: .browseImage,
                            title: "Sepetinde Ürün Yok",
                            subtitle: "Henüz sepetine ürün eklemedin. Ürünlerimizi keşfetmek ister misin? Başlamak için hemen tıkla!",
                            buttonTitle: "Alışverişe Devam Et",
                            buttonColor: .tabbarBackgroundColor,
                            buttonAction: { [weak self] in
                                guard let self,
                                      let tabBarController = self.tabBarController
                                else { return }
                                tabBarController.selectedIndex = 1
                                
                            })
        )
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
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        configureDatasource()
        collectionView.register(nibWithCellClass: CartControlCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartProductCollectionViewCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartBottomProductCollectionViewCell.self, at: Components.bundle)
        collectionView.register(nibWithCellClass: CouponCell.self, at: Bundle.module)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
}

// MARK: - CartViewModelDelegate
extension CartViewController: CartViewModelDelegate {
    func reloadData() {
        applySnapshot()
        collectionView.reloadData()
        controlEmptyViewHiddenStatus()
    }
    
    func hideLoading() {
        hideLoadingView()
    }
    
    func showLoading() {
        showLoadingView()
    }
    
    func setTotalPrice() {
        func updatePriceLabel(label: UILabel, with totalPrice: Double?) {
            let formattedPrice = String(format: "%.2f", totalPrice ?? 0)
            label.text = "\(formattedPrice) $"
        }
        updatePriceLabel(label: totalDiscountCountLabel, with: viewModel.discount)
        updatePriceLabel(label: discountCountLabel, with: viewModel.discount)
        
        updatePriceLabel(label: sumLabelCountofSumStack, with: viewModel.priceToPay)
        updatePriceLabel(label: sumLabelCountofSumStackWithDiscount, with: viewModel.priceToPay)
        
        updatePriceLabel(label: sumCountLabelOfDetailStack, with: viewModel.totalPrice)
        updatePriceLabel(label: discountCountLabel, with: viewModel.discount)
        updatePriceLabel(label: subTotalCountLabel, with: viewModel.subTotal)
        updatePriceLabel(label: cargoFeeCountLabel, with: viewModel.cargoFee)
    }
    
    func deleteDiscountCoupon() {
        couponCell?.deleteCoupon()
    }
    
    func manageSumStackType(isThereDiscount: Bool) {
        sumStackWithDiscount.isHidden = !isThereDiscount
        sumStack.isHidden = isThereDiscount
    }
}

// MARK: - UICollectionViewDelegate
extension CartViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = CartScreenSectionType(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .cart:
            let cartItem = viewModel.products[indexPath.row]
            guard let id = cartItem.id else { return }
            goToDetail(productID: id)
        case .similarProducts:
            let similarItem = viewModel.similarProducts[indexPath.row]
            guard let id = similarItem.id else { return }
            goToDetail(productID: id)
        default:
            break
        }
    }
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
                return topSection()
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
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
                let isSelectAllActive = viewModel.isSelectAllActive
                cell.onSelectAllTapped = {
                    CartManager.shared.updateAllProductsSelection(to: !isSelectAllActive)
                }
                cell.onDeleteAllTapped = {  [weak self] in
                    guard let self else { return }
                    cellOnDeleteTapped()
                }
                cell.configureWith(selectedItemCount: viewModel.selectedItemCount, isSelectAllActive: isSelectAllActive)
                return cell
            case .cart:
                let cell = collectionView.dequeueReusableCell(withClass: CartProductCollectionViewCell.self, for: indexPath)
                let cartItem = viewModel.products[indexPath.row]
                guard let id = cartItem.id, let size = cartItem.size else { return cell }
                let isSelected = viewModel.isSelectedProduct(id: id, size: size)
                cell.configureWith(product: cartItem, discountRate: viewModel.discountRate, isSelected: isSelected)
                cell.onSelectionTapped = {
                    CartManager.shared.updateProductSelection(productId: id, size: size)
                }
                
                cell.onMinusTapped = {  [weak self] in
                    guard let self else { return }
                    cellOnMinusTapped(id: id, size: size)
                }
                
                cell.onPlusTapped = { [weak self] in
                    guard let self else { return }
                    cellOnPlusTapped(id: id, size: size)
                }
                return cell
            case .coupon:
                let cell = collectionView.dequeueReusableCell(withClass: CouponCell.self, for: indexPath)
                couponCell = cell
                cell.onApplyTapped = { [weak self] couponText in
                    guard let self else { return }
                    viewModel.controlCoupon(couponText: couponText)
                    let isDiscountCouponValid = viewModel.discountRate == nil ? false : true
                    cell.isDiscountCouponValid?(isDiscountCouponValid)
                    collectionView.reloadData()
                 }
                return cell
            case .similarProducts:
                let cell = collectionView.dequeueReusableCell(withClass: CartBottomProductCollectionViewCell.self, for: indexPath)
                let product = viewModel.similarProducts[indexPath.row]
                cell.configureWith(product: product)
                cell.onAddToCartTapped = {  [weak self] in
                    guard let self else { return }
                    cellOnAddToCartTapped(product: product)
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
            snapshot.appendItems(["couponSection"], toSection: .coupon)
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

//MARK: - Helpers
private extension CartViewController {
    final func cellOnMinusTapped(id: Int, size: String) {
        showLoadingView()
        CartManager.shared.removeFromCart(productId: id, size: size)
    }
    
    final func cellOnPlusTapped(id: Int, size: String) {
        showLoadingView()
        CartManager.shared.addToCart(productId: id, size: size)
    }
    
    final func cellOnDeleteTapped() {
        guard viewModel.selectedItemCount > 0 else { return }
        showLoadingView()
        CartManager.shared.removeAllSelectedFromCart()
    }
        
    final func cellOnAddToCartTapped(product: ProductResponseElement) {
        let detailBottomVC = DetailBottomViewController(product: product)
        detailBottomVC.modalPresentationStyle = .overFullScreen
        detailBottomVC.modalTransitionStyle = .crossDissolve
        present(detailBottomVC, animated: true, completion: nil)
    }

    final func controlEmptyViewHiddenStatus() {
        emptyView.isHidden = viewModel.products.isEmpty ? false : true
    }
    
    final func goToDetail(productID: Int) {
        let detailProductVC = ProductDetailViewController(productID: productID, products: [])
        detailProductVC.modalPresentationStyle = .overFullScreen
        detailProductVC.modalTransitionStyle = .crossDissolve
        present(detailProductVC, animated: true, completion: nil)
    }
    
}
