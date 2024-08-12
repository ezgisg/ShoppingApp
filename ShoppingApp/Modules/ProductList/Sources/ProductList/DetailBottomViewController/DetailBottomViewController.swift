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
    
    var product: ProductResponseElement
    
    // MARK: - Module Components
    public var viewModel: DetailBottomViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: datanın doğru gelmeme durumu ele alınacak
        guard let productId = product.id else { 
            dismiss(animated: false, completion: nil)
            return }
        viewModel?.loadStockData(for: productId)
        setupInitialData()
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
        print(data)
    }
}

extension DetailBottomViewController {
    func setupInitialData() {
        titleLabel.text = "Sepete Hızlı Ekle"
        categoryLabel.text = product.category
        productLabel.text = product.title
        priceLabel.text = String(product.price ?? 0)
        sizeLabel.text = "Beden"
        goToDetailLabel.text = "Ürün Detay Sayfasına Git"
        choseSizeButton.setTitle("Beden Seç", for: .normal)
        cancelButton.setTitle("İptal", for: .normal)
    }
}
