//
//  FilterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import AppResources
import Base
import UIKit

//TODO:localizable

// MARK: - FilterViewController
final class FilterViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Module Components
    private var viewModel = FilterViewModel()
    
    // MARK: - Variables
    var categories: [CategoryResponseElement] = []
    var selectedCategories: Set<CategoryResponseElement> = []
    var selectedRatings: Set<RatingOption> = []
    var selectedPrices: Set<PriceOption> = []
    
    var onCategoriesSelected: ((Set<CategoryResponseElement>) -> Void)?
    var onRatingsSelected: ((Set<RatingOption>)->Void)?
    var onPricesSelected: ((Set<PriceOption>)->Void)?
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//TODO: Localizable
//MARK: - Setups
private extension FilterViewController {
    final func setupUI() {
        self.title = "Filtreleme"
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.tabbarBackgroundColor
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedColor]
        
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        
        containerView.backgroundColor = .tabbarBackgroundColor
        buttonContainerView.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.backgroundColor = .tabbarBackgroundColor
        button.tintColor = .tabbarBackgroundColor
        button.setTitleColor(.tabbarSelectedColor, for: .normal)
        button.setTitleColor(.lightButtonColor, for: .highlighted)
        button.setTitle("Listele", for: .normal)
        
        setupCustomBackButton()
        setupCustomRightButton()
    }
    
    final func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}


//TODO: image ları asset olarak ekle
//MARK: - Actions
private extension FilterViewController {
    final func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle(nil, for: .normal)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    final func setupCustomRightButton() {
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Temizle", for: .normal)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc final func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    //TODO: Filtreleme yoksa alert göstermeden doğrudan geriye dönecek
    @objc final func didTapBackButton() {
        showAlert(title: "Filtrelemeden Çıkış", message: "Filtreleri silmek istediğine emin misin? Silersen seçimin geçerli olmayacak.", buttonTitle: "Sil", showCancelButton: true, cancelButtonTitle: "Vazgeç") {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.navigationBar.backgroundColor = .clear
        }
    }
    
    //TODO: filtreleme yoksa button pasif olacak
    @objc final func didTapRightButton() {
        print("Filtreleme temizlendi")
    }
    
    @IBAction final func buttonTapped(_ sender: Any) {
        if let onCategoriesSelected {
            onCategoriesSelected(selectedCategories)
        }
        if let onRatingsSelected {
            onRatingsSelected(selectedRatings)
        }
        if let onPricesSelected {
            onPricesSelected(selectedPrices)
        }
        dismissView()
    }
}

//MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelectionCell.self, for: indexPath)
        let option = FilterOption.allCases[indexPath.row]
        
        var isThereSubtitle = false
        var subtitleText = ""
        var text = option.stringValue
        
        switch option {
        case .rating:
            if selectedRatings.count != 0 {
                let ratingsValuesString = selectedRatings.map { $0.stringValue }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = ratingsValuesString
                text = "\(option.stringValue) (\(selectedRatings.count))"
            }
            cell.configureWith(text: text, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        case .price:
            if selectedPrices.count != 0 {
                let ratingsValuesString = selectedPrices.map { $0.stringValue }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = ratingsValuesString
                text = "\(option.stringValue) (\(selectedPrices.count))"
            }
            cell.configureWith(text: text, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        case .category:
            if selectedCategories.count != 0 {
                let categoryValuesString = selectedCategories.map { $0.value ?? "N/A" }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = categoryValuesString
                text = "\(option.stringValue) (\(selectedCategories.count))"
            }
            cell.configureWith(text: text, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = FilterOption.allCases[indexPath.row]
        let detailVC = FilterDetailViewController(filterOptionType: option)
        detailVC.categories = categories
        detailVC.selectedCategories = selectedCategories
        detailVC.selectedPrices = selectedPrices
        detailVC.selectedRatings = selectedRatings
        detailVC.onCategoriesSelected = { [weak self]  selectedCategories in
            guard let self else { return }
            self.selectedCategories = selectedCategories
        }
        detailVC.onPricesSelected = { [weak self]  selectedPrices in
            guard let self else { return }
            self.selectedPrices = selectedPrices
        }
        detailVC.onRatingsSelected = { [weak self]  selectedRatings in
            guard let self else { return }
            self.selectedRatings = selectedRatings
        }
        navigationController?.pushViewController(detailVC, animated: false)
    }
}
