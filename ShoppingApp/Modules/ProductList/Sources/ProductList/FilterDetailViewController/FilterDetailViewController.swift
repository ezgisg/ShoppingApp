//
//  FilterDetailViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 8.08.2024.
//

//TODO: tek kategorililerde taşımyıoruz, taşıyıp homeda da düzeltme gerek
//TODO: tek viewmodel ile de denenecek
//TODO: geri butonu localizable ve categories harici seçimler vs eksik..

import AppResources
import Base
import UIKit


// MARK: - FilterDetailViewController
final class FilterDetailViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    var filterOptionType: FilterOption
    var categories: [CategoryResponseElement] = []
    var selectedCategories: Set<CategoryResponseElement> = []
    
    //TODO: ratings de multiple selection engellenecek ya da caseleri değiştirelim 2-3 3-4 4-5 gibi ..
    var selectedRatings: Set<RatingOption> = []
    var selectedPrices: Set<PriceOption> = []
    
    var initialSelectedCategories: Set<CategoryResponseElement> = []
    var initialSelectedRatings: Set<RatingOption> = []
    var initialSelectedPrices: Set<PriceOption> = []
    
    var onCategoriesSelected: ((Set<CategoryResponseElement>) -> Void)?
    var onRatingsSelected: ((Set<RatingOption>)->Void)?
    var onPricesSelected: ((Set<PriceOption>)->Void)?
    
    var isRightButtonForClear: Bool = true
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupInitialSelections()
    }
    
    // MARK: - Module init
    public init(filterOptionType: FilterOption) {
        self.filterOptionType = filterOptionType
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}

//MARK: - Actions
private extension FilterDetailViewController {
    @IBAction func buttonTapped(_ sender: Any) {
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
    
    @objc final func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
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
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightButtonItem
        controlButtonStatus()
    }
      
    //TODO: Filtreleme yoksa alert göstermeden doğrudan geriye dönecek
    @objc final func didTapBackButton() {
        guard selectedPrices != initialSelectedPrices ||
                selectedRatings != initialSelectedRatings ||
                selectedCategories != initialSelectedCategories else { return dismissView()  }
        showAlert(title: "Filtrelemeden Çıkış", message: "Filtreleri silmek istediğine emin misin? Silersen seçimin geçerli olmayacak.", buttonTitle: "Sil", showCancelButton: true, cancelButtonTitle: "Vazgeç") {  [weak self] in
            guard let self else { return }
            dismissView()
        }
    }
    
    //TODO: filtreleme yoksa button pasif olacak
    @objc final func didTapRightButton() {
        clearAllFilter()
    }
}

//MARK: - Setups
private extension FilterDetailViewController {
    final func setupUI() {
        self.title = "Filtreleme detay"
        
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
        setupInitialSelections()
    }
    
    final func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    
    func setupInitialSelections() {
        var indexes: [IndexPath] = []
        switch filterOptionType {
        case .rating:
            for rating in selectedRatings {
                if let index = RatingOption.allCases.firstIndex(of: rating) {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexes.append(indexPath)
                }
            }
        case .price:
            for price in selectedPrices {
                if let index = PriceOption.allCases.firstIndex(of: price) {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexes.append(indexPath)
                }
            }
        case .category:
            for selectedCategory in selectedCategories {
                if let index = categories.firstIndex(of: selectedCategory) {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexes.append(indexPath)
                }
            }
        }

        for indexPath in indexes {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
        
    }
    
}

//MARK: - UITableViewDataSource
extension FilterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterOptionType {
        case .rating, .price:
            (filterOptionType.options as AnyObject).count ?? 0
        case .category:
            categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelectionCell.self, for: indexPath)
        switch filterOptionType {
        case .rating:
            cell.configureWith(text: RatingOption.allCases[indexPath.row].stringValue, containerViewBackgroundColor: .clear)
        case .price:
            cell.configureWith(text: PriceOption.allCases[indexPath.row].stringValue, containerViewBackgroundColor: .clear)
        case .category:
            cell.configureWith(text: categories[indexPath.row].value ?? "", containerViewBackgroundColor: .clear)
        }
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension FilterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filterOptionType {
        case .rating:
            print(indexPath)
            let selectedRating = RatingOption.allCases[indexPath.row]
            selectedRatings.insert(selectedRating)
        case .price:
            let selectedPrice = PriceOption.allCases[indexPath.row]
            selectedPrices.insert(selectedPrice)
        case .category:
            let selectedCategory = categories[indexPath.row]
            selectedCategories.insert(selectedCategory)
        }
        controlButtonStatus()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch filterOptionType {
        case .rating:
            let selectedRating = RatingOption.allCases[indexPath.row]
            selectedRatings.remove(selectedRating)
        case .price:
            let selectedPrice = PriceOption.allCases[indexPath.row]
            selectedPrices.remove(selectedPrice)
        case .category:
            let selectedCategory = categories[indexPath.row]
            selectedCategories.remove(selectedCategory)
            
        }
        controlButtonStatus()
    }
    
}


//MARK: - Helpers
private extension FilterDetailViewController {
    final func controlButtonStatus() {
        let count = selectedPrices.count + selectedRatings.count + selectedCategories.count
        isRightButtonForClear = count > 0 ? true : false
        let newTitle = isRightButtonForClear ? "Temizle" : "Hepsini Seç"
        guard let rightButton = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
        
        rightButton.setTitle(newTitle, for: .normal)
        rightButton.sizeToFit()
    }
    final func clearAllFilter() {
        let count = selectedPrices.count + selectedRatings.count + selectedCategories.count
        if count > 0,
            isRightButtonForClear {
            selectedPrices = []
            selectedRatings = []
            selectedCategories = []
            tableView.reloadData()
        } else {
            switch filterOptionType {
            case .rating:
                selectedRatings = Set(RatingOption.allCases)
            case .price:
                selectedPrices = Set(PriceOption.allCases)
            case .category:
                selectedCategories = Set(categories)
            }
            setupInitialSelections()
    
            
        }
        controlButtonStatus()
    }
}
