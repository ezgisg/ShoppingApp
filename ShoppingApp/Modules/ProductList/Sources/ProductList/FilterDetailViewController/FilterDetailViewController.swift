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
    
    // MARK: - Module Components
    public var viewModel: ProductListViewModelProtocol
    
    //MARK: - Variables
    var filterOptionType: FilterOption
    
    var isRightButtonForClear: Bool = true
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        keepInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.filterDelegate = self
        setupInitialSelections()
    }
    
    // MARK: - Module init
    public init(filterOptionType: FilterOption, viewModel: ProductListViewModelProtocol) {
        self.viewModel = viewModel
        self.filterOptionType = filterOptionType
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    final func setupInitialSelections() {
        let indexes = viewModel.getIndexOfSelection(for: filterOptionType)
        for indexPath in indexes {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
}

//MARK: - Actions
private extension FilterDetailViewController {
    @objc final func didTapBackButton() {
        let isDifferentFromInitials = viewModel.isDifferentFromInitialsOnFilterDetail
        guard isDifferentFromInitials else { return dismissView() }
        showAlert(title: "Filtrelemeden Çıkış", message: "Filtreleri silmek istediğine emin misin? Silersen seçimin geçerli olmayacak.", buttonTitle: "Sil", showCancelButton: true, cancelButtonTitle: "Vazgeç") {  [weak self] in
            guard let self else { return }
            returnToInitials()
            dismissView()
        }
    }
    
    @objc final func didTapRightButton() {
        viewModel.clearOrSelectAllFilters(filterOptionType: filterOptionType)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dismissView()
    }
    
    @objc final func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension FilterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterOptionType {
        case .rating:
            return RatingOption.allCases.count
        case .price:
            return PriceOption.allCases.count
        case .category:
            return viewModel.categories.count
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
            cell.configureWith(text: viewModel.categories[indexPath.row].value ?? "", containerViewBackgroundColor: .clear)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FilterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filterOptionType {
        case .rating:
            let selectedRating = RatingOption.allCases[indexPath.row]
            viewModel.selectedRatings.insert(selectedRating)
        case .price:
            let selectedPrice = PriceOption.allCases[indexPath.row]
            viewModel.selectedPrices.insert(selectedPrice)
        case .category:
            let selectedCategory = viewModel.categories[indexPath.row]
            viewModel.selectedCategories.insert(selectedCategory)
        }
        controlButtonStatus()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch filterOptionType {
        case .rating:
            let selectedRating = RatingOption.allCases[indexPath.row]
            viewModel.selectedRatings.remove(selectedRating)
        case .price:
            let selectedPrice = PriceOption.allCases[indexPath.row]
            viewModel.selectedPrices.remove(selectedPrice)
        case .category:
            let selectedCategory = viewModel.categories[indexPath.row]
            viewModel.selectedCategories.remove(selectedCategory)
        }
        controlButtonStatus()
    }
}


//MARK: - Helpers
private extension FilterDetailViewController {
    final func controlButtonStatus() {
        var count: Int {
            switch filterOptionType {
            case .rating:
                viewModel.selectedRatings.count
            case .price:
                viewModel.selectedPrices.count
            case .category:
                viewModel.selectedCategories.count
            }
        }
        isRightButtonForClear = count > 0 ? true : false
        let newTitle = isRightButtonForClear ? "Temizle" : "Hepsini Seç"
        guard let rightButton = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
        rightButton.setTitle(newTitle, for: .normal)
        rightButton.sizeToFit()
        setupInitialSelections()
    }

    final func keepInitials() {
        viewModel.filterDetailInitialSelectedPrices = viewModel.selectedPrices
        viewModel.filterDetailInitialSelectedRatings = viewModel.selectedRatings
        viewModel.filterDetailInitialSelectedCategories = viewModel.selectedCategories
    }
    
    final func returnToInitials() {
        viewModel.selectedPrices = viewModel.filterDetailInitialSelectedPrices
        viewModel.selectedRatings = viewModel.filterDetailInitialSelectedRatings
        viewModel.selectedCategories = viewModel.filterDetailInitialSelectedCategories
    }
}

extension FilterDetailViewController: FilterDelegate {
    func controlAllButtonStatus() {
        controlButtonStatus()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setupSelections() {
        setupInitialSelections()
    }
}
