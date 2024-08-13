//
//  DetailBottomViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//


//TODO: localizable
import UIKit
import AppResources

class DetailBottomViewController: UIViewController {

    
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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var product: ProductResponseElement
    var productSizeData: ProductStockModel?
    var selectedSize: String? = nil {
        didSet {
            if let selectedSize {
                choseSizeButton.isEnabled = true
            } else {
                choseSizeButton.isEnabled = false
            }
        }
    }
    
    // MARK: - Module Components
    public var viewModel = DetailBottomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: datanın doğru gelmeme durumu ele alınacak
        viewModel.delegate = self
        guard let productId = product.id else {
            dismiss(animated: false, completion: nil)
            return }
        viewModel.loadStockData(for: productId)
        setups()
        
        if let sizes = productSizeData?.sizes,
               sizes.count == 1 {
            selectedSize = sizes[0].size
        }
        choseSizeButton.isEnabled = false
    }
    
    
    // MARK: - Module init
    public init(product: ProductResponseElement) {
        self.product = product
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedChoseSizeButton(_ sender: Any) {
    }
    
}

extension DetailBottomViewController: DetailBottomViewModelDelegate {
    func getProductData(data: ProductStockModel) {
        productSizeData = data
        collectionView.reloadData()
    }
}


//MARK: - Setups
extension DetailBottomViewController {
    func setups() {
        setupTexts()
        setupBackgroundColors()
        setupTextColors()
        setupUI()
        setupImage()
        setupCollectionView()
    }
    
    func setupTexts() {
        titleLabel.text = "Sepete Hızlı Ekle"
        categoryLabel.text = product.category
        productLabel.text = product.title
        sizeLabel.text = "Beden"
//        goToDetailLabel.text = "Ürün Detay Sayfasına Git"
        choseSizeButton.setTitle("Beden Seç", for: .normal)
        cancelButton.setTitle("İptal", for: .normal)
        if let price = product.price {
            priceLabel.text = "\(String(price)) $"
        }
    }
    
    func setupBackgroundColors() {
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        headerView.backgroundColor = .tabbarBackgroundColor
        choseSizeButton.backgroundColor = .tabbarBackgroundColor
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        containerView.layer.shadowOpacity = 0.5
    }
    
    func setupTextColors() {
        titleLabel.textColor = .buttonTextColor
        cancelButton.setTitleColor(.buttonTextColor, for: .normal)
        choseSizeButton.setTitleColor(.buttonTextColor, for: .normal)
        categoryLabel.textColor = .black
        productLabel.textColor = .black
        priceLabel.textColor = .black
        sizeLabel.textColor = .darkGray
        goToDetailLabel.textColor = .black
    }
    
    func setupUI() {
        choseSizeButton.layer.cornerRadius = 8
        let attributedString = NSMutableAttributedString(string: "Ürün Detay Sayfasına Git")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        goToDetailLabel.attributedText = attributedString
    }
    
    func setupImage() {
        guard let urlString = product.image, let url = URL(string: urlString)
        else { return imageView.image = .noImage }
        imageView.loadImage(with: url, contentMode: .scaleAspectFit)
    }
}

//MARK: - CollectionView Setups
extension DetailBottomViewController {
    final func setupCollectionView() {
        collectionView.register(nibWithCellClass: FilterCell.self, at: Bundle.module)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
    }
}

//MARK: - UICollectionViewDataSource
extension DetailBottomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productSizeData?.sizes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FilterCell.self, for: indexPath)
        let size = productSizeData?.sizes[indexPath.row].size
        let stockCount = productSizeData?.sizes[indexPath.row].stock
        cell.isEnabled = stockCount ?? 0 > 0
        cell.isUserInteractionEnabled = stockCount ?? 0 > 0
        if stockCount ?? 0 > 0 {
            cell.isSelectedCell = selectedSize == size
        } else {
            cell.isSelectedCell = false
        }
        cell.configureWith(text: size, textFont: .systemFont(ofSize: 20))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailBottomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSize == productSizeData?.sizes[indexPath.row].size {
            selectedSize = nil
        } else {
            selectedSize = productSizeData?.sizes[indexPath.row].size
        }
        collectionView.reloadData()
        print("seçildi")
    }
    
}

extension DetailBottomViewController {
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

