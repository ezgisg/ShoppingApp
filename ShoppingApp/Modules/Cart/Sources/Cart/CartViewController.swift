//
//  CartViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import AppResources
import UIKit

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

public class CartViewController: UIViewController {
    
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
        viewModel.delegate = self
        setups()
    }
    

    public override func viewWillAppear(_ animated: Bool) {
        viewModel.getCartDatas()
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
        collectionView.backgroundColor = .white
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
        collectionView.register(nibWithCellClass: CartProductCollectionViewCell.self, at: Bundle.module)
        collectionView.register(nibWithCellClass: CartBottomProductCollectionViewCell.self, at: Bundle.module)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
}

extension CartViewController: CartViewModelDelegate {
    func reloadData(cart: [ProductResponseElement]) {
        applySnapshot()
        collectionView.reloadData()
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
                return cartSection()
            case .cart:
                return cartSection()
            case .coupon:
                return cartSection()
            case .similarProducts:
                return cartSection()
            }
        }
    }
    
    final func cartSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(136))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(136))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)
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
                return UICollectionViewCell()
            case .cart:
                let cell = collectionView.dequeueReusableCell(withClass: CartProductCollectionViewCell.self, for: indexPath)
                var cartItem = viewModel.products[indexPath.row]
                cell.configureWith(product: cartItem, discountedPrice: nil)
                cell.onSelectionTapped = {
                    guard let id = cartItem.id, let size = cartItem.size else { return }
                    CartManager.shared.updateProductSelection(productId: id, size: size)
                }
                return cell
            case .coupon:
                return UICollectionViewCell()
            case .similarProducts:
                return UICollectionViewCell()
            }
        })
        applySnapshot()
    }
    
    final func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CartScreenSectionType, AnyHashable>()
        for section in CartScreenSectionType.allCases {
            snapshot.appendSections([section])
        }
    
        snapshot.appendItems(viewModel.products, toSection: .cart)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
