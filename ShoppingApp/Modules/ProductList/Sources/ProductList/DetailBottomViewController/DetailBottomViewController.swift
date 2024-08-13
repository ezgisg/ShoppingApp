//
//  DetailBottomViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

//TODO: localizable
import UIKit
import AppResources

// MARK: - DetailBottomViewController
class DetailBottomViewController: UIViewController {
    
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
    
    // MARK: - Variables
    var product: ProductResponseElement

    // MARK: - Module Components
    public var viewModel = DetailBottomViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: datanın doğru gelmeme durumu ele alınacak
        viewModel.delegate = self
        guard let productId = product.id
        else {
            dismiss(animated: false, completion: nil)
            return
        }
        viewModel.loadStockData(for: productId)
        setups()
    }
    
    // MARK: - Module init
    public init(product: ProductResponseElement) {
        self.product = product
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
    
    //TODO: sepete ekleme aksiyonu eklenecek-stock bilgisi kontrolü ile
    @IBAction final func tappedChoseSizeButton(_ sender: Any) {
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
    }
    
    final func setupTexts() {
        titleLabel.text = "Sepete Hızlı Ekle"
        categoryLabel.text = product.category
        productLabel.text = product.title
        sizeLabel.text = "Beden"
        choseSizeButton.setTitle("Sepete ekle", for: .normal)
        cancelButton.setTitle("İptal", for: .normal)
        if let price = product.price {
            priceLabel.text = "\(String(price)) $"
        }
        let attributedString = NSMutableAttributedString(string: "Ürün Detay Sayfasına Git")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        goToDetailLabel.attributedText = attributedString
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
    }
    
    final func setupTextColors() {
        titleLabel.textColor = .buttonTextColor
        cancelButton.setTitleColor(.buttonTextColor, for: .normal)
        choseSizeButton.setTitleColor(.buttonTextColor, for: .normal)
        categoryLabel.textColor = .black
        productLabel.textColor = .black
        priceLabel.textColor = .black
        sizeLabel.textColor = .darkGray
        goToDetailLabel.textColor = .black
    }
    
    final func setupInitialStatus() {
        ///It is disabled at first because it change by (as it below) selected size changes
        choseSizeButton.isEnabled = false
        if let sizes = viewModel.productSizeData?.sizes,
               sizes.count == 1 {
            viewModel.selectedSize = sizes[0].size
        }
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productSizeData?.sizes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FilterCell.self, for: indexPath)
        guard let sizeData = viewModel.productSizeData?.sizes[indexPath.row] else { return cell }
        let isInStock = sizeData.stock > 0
        cell.isEnabled = isInStock
        cell.isSelectedCell = isInStock && viewModel.selectedSize == sizeData.size
        cell.configureWith(text: sizeData.size, textFont: .systemFont(ofSize: 20))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailBottomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
