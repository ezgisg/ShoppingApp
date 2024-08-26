//
//  DetailBottomViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import AppManagers
import Base
import UIKit

// MARK: - DetailBottomViewController
final class DetailBottomViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var productLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var sizeCollectionView: UICollectionView!
    @IBOutlet private weak var goToDetailLabel: UILabel!
    @IBOutlet private weak var choseSizeButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var warningForAddingCartView: UIView!
    @IBOutlet private weak var warningForAddingCartLabel: UILabel!
    
    // MARK: - Variables
    var product: ProductResponseElement

    // MARK: - Module Components
    private var viewModel: DetailBottomViewModel
    private var coordinator: ProductListCoordinator
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: datanın doğru gelmeme durumu ele alınacak
        viewModel.delegate = self
        guard 
            let productId = product.id
        else {
            dismiss(animated: false, completion: nil)
            return
        }
        viewModel.loadStockData(for: productId)
        setups()
    }
    
    // MARK: - Module init
    init(
        product: ProductResponseElement,
        viewModel: DetailBottomViewModel,
        coordinator: ProductListCoordinator
    ) {
        self.product = product
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}

//MARK: Actions
private extension DetailBottomViewController {
    @IBAction final func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction final func tappedChoseSizeButton(_ sender: Any) {
        let size = viewModel.selectedSize
        let productId = product.id
        //TODO: eklendiğinde eklendi uyarısı else de sepee eklenemedi hatası verebiliriz
        guard let productId, let size else { return }
        CartManager.shared.addToCart(productId: productId, size: size)
        ///Adding another view for handling animation easily otherwise to have to manage enabling-title etc. if the size selection is changed while add to cart is enabled
        warningForAddingCartView.alpha = 0
        warningForAddingCartView.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {  [weak self] in
            guard let self else { return }
            warningForAddingCartView.alpha = 1
        }, completion: { [weak self] _ in
            guard let self else { return }
            UIView.animate(withDuration: 0.3, delay: 1, options: [], animations: {  [weak self] in
                guard let self else { return }
                warningForAddingCartView.alpha = 0
            }, completion: {  [weak self] _ in
                guard let self else { return }
                warningForAddingCartView.isHidden = true
                warningForAddingCartView.alpha = 1
            })
        })
        
    }

    @objc final func goToDetail() {
        guard let productID = product.id else { return }
        dismiss(animated: true) {  [weak self] in
            guard let self else { return }
            coordinator.routeToProductDetail(productID: productID, products: [])
        }
    }
}

//MARK: - Setups
private extension DetailBottomViewController {
    final func setups() {
        setupTexts()
        setupBackgrounds()
        setupTextColors()
        setupInitialStatus()
        setupImage()
        setupCollectionView()
        addTapGesture()
    }
    
    final func setupTexts() {
        titleLabel.text = L10nGeneric.CartTexts.speedReview.localized()
        categoryLabel.text = product.category
        productLabel.text = product.title
        sizeLabel.text = L10nGeneric.CartTexts.variant.localized()
        choseSizeButton.setTitle(L10nGeneric.addToCart.localized(), for: .normal)
        cancelButton.setTitle(L10nGeneric.abort.localized(), for: .normal)
        if let price = product.price {
            priceLabel.text = "\(String(price)) $"
        }
        let attributedString = NSMutableAttributedString(string: L10nGeneric.CartTexts.goToDetail.localized())
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        goToDetailLabel.attributedText = attributedString
        warningForAddingCartLabel.text = L10nGeneric.CartTexts.addedToCart.localized()
    }
    
    final func addTapGesture() {
        let goToDetailGesture = UITapGestureRecognizer(target: self, action: #selector(goToDetail))
        goToDetailLabel.addGestureRecognizer(goToDetailGesture)
        goToDetailLabel.isUserInteractionEnabled = true
    }
    
    final func setupBackgrounds() {
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        headerView.backgroundColor = .tabbarBackgroundColor
        choseSizeButton.backgroundColor = .tabbarBackgroundColor
        choseSizeButton.layer.cornerRadius = 8
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        containerView.layer.shadowOpacity = 0.5
        warningForAddingCartView.backgroundColor = .systemYellow
        warningForAddingCartView.layer.cornerRadius = 8
    }
    
    final func setupTextColors() {
        titleLabel.textColor = .buttonTextColor
        cancelButton.setTitleColor(.buttonTextColor, for: .normal)
        choseSizeButton.setTitleColor(.buttonTextColor, for: .normal)
        choseSizeButton.setTitleColor(.lightGray.withAlphaComponent(0.5), for: .disabled)
        categoryLabel.textColor = .black
        productLabel.textColor = .black
        priceLabel.textColor = .black
        sizeLabel.textColor = .darkGray
        goToDetailLabel.textColor = .black
        warningForAddingCartLabel.textColor = .black
    }
    
    final func setupInitialStatus() {
        choseSizeButton.isEnabled = viewModel.isAddCartButtonEnabled ?? false
    }
    
    final func setupImage() {
        guard let urlString = product.image, let url = URL(string: urlString)
        else { return imageView.image = .noImage }
        imageView.loadImage(with: url, contentMode: .scaleAspectFit)
    }
    
    final func setupCollectionView() {
        collectionView.register(nibWithCellClass: FilterCell.self, at: Bundle.module)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
    }
}

//MARK: - UICollectionViewDataSource
extension DetailBottomViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productSizeData?.sizes.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FilterCell.self, for: indexPath)
        guard let sizeData = viewModel.productSizeData?.sizes[indexPath.row] else { return cell }

        cell.isEnabled = viewModel.isEnabledisSelected(index: indexPath.row).0
        cell.isSelectedCell = viewModel.isEnabledisSelected(index: indexPath.row).1
        cell.configureWith(text: sizeData.size, textFont: .systemFont(ofSize: 20))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailBottomViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newSize = viewModel.productSizeData?.sizes[indexPath.row].size else { return }
        viewModel.selectedSize = viewModel.selectedSize == newSize ? nil : newSize
        collectionView.reloadData()
    }
}

//MARK: - Compositional Layout
private extension DetailBottomViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createSizeSection()
        }
    }
    
    final func createSizeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(20), heightDimension: .absolute(36))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(20),  heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        return section
    }
}

//MARK: DetailBottomViewModelDelegate
extension DetailBottomViewController: DetailBottomViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func controlAddToCartButtonStatus(isEnabled: Bool) {
        choseSizeButton.isEnabled = isEnabled
    }
}

