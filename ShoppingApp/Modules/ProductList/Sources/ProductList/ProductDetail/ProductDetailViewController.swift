//
//  ProductDetailViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 21.08.2024.
//

import AppManagers
import AppResources
import Base
import Combine
import Components
import UIKit

// MARK: - Enums
enum ProductDetailSectionType: Int, CaseIterable {
    case product = 0
    case variant = 1
    case details = 2
    case suggestions = 3
    case payment = 4
}

// MARK: - ProductDetailViewController
final class ProductDetailViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomBackView: UIView!
    @IBOutlet private weak var addCartButton: UIButton!
    @IBOutlet private weak var topView: UIView!
    
    //MARK: Initials
    var productID: Int
    ///For using in similars section as a mock data. It includes product itself.
    var products: ProductListResponse
    var filteredProductsExcluding: ProductListResponse?
    
    // MARK: - Properties
    private var onScreenDismiss: (() -> Void)?
    
    // MARK: - Private Variables
    private var cancellables: Set<AnyCancellable> = []
    ///To prevent executing cart subscriber sink operations in start. Actually currentvaluesubject can be used for this but in this case there must be two different type publisher in cart manager for same action.
    private var isFirstLaunch: Bool = true
    
    // MARK: - Module Components
    ///Logic is same so there is common viewmodel
    private var viewModel: DetailBottomViewModel
    private var coordinator: ProductListCoordinator
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadStockData(for: productID)
        viewModel.fetchProduct(productId: productID)
        setups()
        topView.isHidden = true
        getCartWithCombine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ///It is called at willappear, otherwise it is called on the previous screen
        showLoadingView()
        filteredProductsExcluding = products.filter{ $0.id != productID }
    }
    
    // MARK: - Module init
    init(
        productID: Int,
        products: ProductListResponse,
        viewModel: DetailBottomViewModel,
        coordinator: ProductListCoordinator,
        onScreenDismiss: (() -> Void)?
    ) {
        self.productID = productID
        self.products = products
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.onScreenDismiss = onScreenDismiss
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Actions
extension ProductDetailViewController {
    @IBAction func tappedAddButton(_ sender: Any) {
        let size = viewModel.selectedSize
        guard let size else { return }
        addCartButton.isEnabled = false
        topView.isHidden = false
        CartManager.shared.addToCart(productId: productID, size: size)
    }
}

//MARK: - Setups
private extension ProductDetailViewController {
    final func setups() {
        setupCollectionView()
        setupUI()
        setupInitialStatus()
    }
    
    final func setupUI() {
        collectionView.backgroundColor = .white
        
        bottomBackView.backgroundColor = .white
        bottomBackView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomBackView.layer.shadowColor = UIColor.black.cgColor
        bottomBackView.layer.shadowOpacity = 0.5
        
        backView.backgroundColor = .tabbarBackgroundColor
        
        addCartButton.layer.cornerRadius = 8
        addCartButton.setTitleColor(.lightDividerColor, for: .normal)
        addCartButton.setTitleColor(.white, for: .disabled)
    }
    
    final func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: ProductDetailCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: FilterCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: DescriptionCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: PaymentCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartBottomProductCollectionViewCell.self, at: Components.bundle)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func setupInitialStatus() {
        addCartButton.isEnabled = viewModel.isAddCartButtonEnabled ?? false
        setButtonColor(isEnabled: addCartButton.isEnabled)
    }
    
    final func getCartWithCombine() {
        CartManager.shared.cartItemsPublisher
            .sink { _ in
            } receiveValue: {  [weak self] _ in
                guard let self else { return }
                guard !isFirstLaunch else {
                    isFirstLaunch = false
                    return
                }
                addCartButton.backgroundColor = .systemYellow
                addCartButton.setTitle(L10nGeneric.CartTexts.addedToCart.localized(), for: .disabled)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  [weak self] in
                    guard let self else { return }
                    addCartButton.isEnabled = true
                    setButtonColor(isEnabled: self.addCartButton.isEnabled)
                    topView.isHidden = true
                }
            }.store(in: &cancellables)
    }
}

//MARK: - Compositional Layout
private extension ProductDetailViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = ProductDetailSectionType(rawValue: sectionIndex)
            else { return nil }
            
            switch sectionType {
            case .product:
                return createProductSection()
            case .variant:
                return createVariantSection()
            case .details:
                return createBasicSection(isSectionCertainlyExist: false)
            case .suggestions:
                return similarSection()
            case .payment:
                return createBasicSection(isSectionCertainlyExist: true)
            }
        }
    }
    
    final func createProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)
        return section
    }
    
    final func createVariantSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(20), heightDimension: .absolute(36))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(20),  heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading:16, bottom: 12, trailing: 16)
    
        return section
    }
    
    final func createBasicSection(isSectionCertainlyExist: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -12, bottom: 0, trailing: -12)
        
        let isThereDescriptionForProduct = !(viewModel.product?.description?.isEmpty ?? true)
        section.boundarySupplementaryItems = isSectionCertainlyExist || isThereDescriptionForProduct ? [header] : []
        
        return section
    }
    
    final func similarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(112), heightDimension: .estimated(193))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(112), heightDimension: .estimated(193))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
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
        
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: -8)
        if filteredProductsExcluding?.count ?? 0 > 0 {
            section.boundarySupplementaryItems = [header]
        }
        return section
    }
}

//MARK: - UICollectionViewDelegate
extension ProductDetailViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = ProductDetailSectionType(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .variant:
            let previousSize = viewModel.selectedSize
            let previousIndex = viewModel.productSizeData?.sizes.firstIndex(where: {$0.size == previousSize })
            let previousIndexPath = IndexPath(row: previousIndex ?? indexPath.row, section: indexPath.section)
            
            guard let newSize = viewModel.productSizeData?.sizes[indexPath.row].size else { return }
            viewModel.selectedSize = viewModel.selectedSize == newSize ? nil : newSize
            
            ///To prevent scroll to back when reload changed items
            UIView.animate(withDuration: 0, animations: {
                collectionView.reloadItems(at: [indexPath, previousIndexPath])
            }, completion: { _ in
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            
        case .suggestions:
            guard let selectedProductID = filteredProductsExcluding?[indexPath.row].id else { return }
            
            coordinator.routeToProductDetail(
                productID: selectedProductID,
                products: products
            )
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProductDetailSectionType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = ProductDetailSectionType(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .product:
            let count = viewModel.product != nil ? 1 : 0
            return count
        case .variant:
            return viewModel.productSizeData?.sizes.count ?? 0
        case .details:
            let isThereDescriptionForProduct = !(viewModel.product?.description?.isEmpty ?? true)
            return isThereDescriptionForProduct ? 1 : 0
        case .suggestions:
            return filteredProductsExcluding?.count ?? 0
        case .payment:
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = ProductDetailSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch sectionType {
        case .product:
            let cell = collectionView.dequeueReusableCell(withClass: ProductDetailCell.self, for: indexPath)
            cell.onDismissTapped = {  [weak self] in
                guard let self else { return }
                dismiss(animated: true, completion: nil)
                onScreenDismiss?()
            }
            cell.onFavoriteTapped = {  [weak self] in
                guard let self else { return }
                handleFavoriteTap(for: viewModel.product)
            }
            cell.configureWith(product: viewModel.product)
            return cell
        case .variant:
            let cell = collectionView.dequeueReusableCell(withClass: FilterCell.self, for: indexPath)
            guard let sizeData = viewModel.productSizeData?.sizes[indexPath.row] else { return cell }
            cell.isEnabled = viewModel.isEnabledisSelected(index: indexPath.row).0
            cell.isSelectedCell = viewModel.isEnabledisSelected(index: indexPath.row).1
            cell.configureWith(text: sizeData.size, textFont: .systemFont(ofSize: 20))
            return cell
        case .details:
            let cell = collectionView.dequeueReusableCell(withClass: DescriptionCell.self, for: indexPath)
            cell.configureWith(text: viewModel.product?.description ?? "")
            return cell
        case .suggestions:
            let cell = collectionView.dequeueReusableCell(withClass: CartBottomProductCollectionViewCell.self, for: indexPath)
            if let product = filteredProductsExcluding?[indexPath.row] {
                cell.configureWith(product: product, isAddToCartButtonHidden: true)
            }
            return cell
        case .payment:
            let cell = collectionView.dequeueReusableCell(withClass: PaymentCell.self, for: indexPath)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let sectionType = ProductDetailSectionType(rawValue: indexPath.section) else { return UICollectionReusableView () }
        
        var title = ""
        switch sectionType {
        case .details:
            title = L10nGeneric.CartTexts.titleProductDescription.localized()
        case .payment:
            title = L10nGeneric.CartTexts.titlePaymentTypes.localized()
        case .suggestions:
            title = L10nGeneric.CartTexts.titleSuggestionsForYou.localized()
        default:
            break
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else { return UICollectionReusableView() }
            headerView.configure(with: title, color: .gray, backgroundColor: .lightDividerColor, leading: 4)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - DetailBottomViewModelDelegate
extension ProductDetailViewController: DetailBottomViewModelDelegate {
    func hideLoading() {
        hideLoadingView()
    }
    
    func controlAddToCartButtonStatus(isEnabled: Bool) {
        addCartButton.isEnabled = isEnabled
        setButtonColor(isEnabled: isEnabled)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func errorWhileFetching() {
        topView.isHidden = false
        topView.backgroundColor = .white
        showAlert(title: L10nGeneric.fetchingProductError.title.localized(), message: L10nGeneric.fetchingProductError.message.localized(), buttonTitle: L10nGeneric.ok.localized()) {  [weak self] in
            guard let self else { return }
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Helpers
private extension ProductDetailViewController {
    final func handleFavoriteTap(for product: ProductResponseElement?) {
        guard let product else { return }
        FavoritesManager.shared.toggleFavorite(product: product)
    }
    
    final func setButtonColor(isEnabled: Bool) {
        addCartButton.backgroundColor = .middleButtonColor.withAlphaComponent(0.5)
        addCartButton.tintColor = isEnabled ? .tabbarBackgroundColor : .clear
        addCartButton.setTitle(L10nGeneric.addToCart.localized(), for: .normal)
    }
}
