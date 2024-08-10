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
    public var viewModel: ProductListViewModelProtocol

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.filterDelegate = self
        keepInitials()
        setupUI()
        setupTableView()
        controlButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Module init
    public init(viewModel: ProductListViewModelProtocol) {
        self.viewModel = viewModel
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
    
    @objc final func didTapBackButton() {
        let isDifferentFromInitials = viewModel.isDifferentFromInitialsOnFilter
        guard isDifferentFromInitials else { return dismissView()  }
        showAlert(title: "Filtrelemeden Çıkış", message: "Filtreleri silmek istediğine emin misin? Silersen seçimin geçerli olmayacak.", buttonTitle: "Sil", showCancelButton: true, cancelButtonTitle: "Vazgeç") {  [weak self] in
            guard let self else { return }
            returnToInitials()
            dismissView()
        }
    }
    
    @objc final func didTapRightButton() {
        viewModel.clearAllFilters()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @IBAction final func buttonTapped(_ sender: Any) {
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
            if viewModel.selectedRatings.count != 0 {
                let ratingsValuesString = viewModel.selectedRatings.map { $0.stringValue }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = ratingsValuesString
                text = "\(option.stringValue) (\(viewModel.selectedRatings.count))"
            }
            cell.configureWith(text: text, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        case .price:
            if viewModel.selectedPrices.count != 0 {
                let ratingsValuesString = viewModel.selectedPrices.map { $0.stringValue }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = ratingsValuesString
                text = "\(option.stringValue) (\(viewModel.selectedPrices.count))"
            }
            cell.configureWith(text: text, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        case .category:
            if viewModel.selectedCategories.count != 0 {
                let categoryValuesString = viewModel.selectedCategories.map { $0.value ?? "N/A" }.joined(separator: ", ")
                isThereSubtitle = true
                subtitleText = categoryValuesString
                text = "\(option.stringValue) (\(viewModel.selectedCategories.count))"
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
        detailVC.categories = viewModel.categories
        detailVC.selectedCategories = viewModel.selectedCategories
        detailVC.selectedPrices = viewModel.selectedPrices
        detailVC.selectedRatings = viewModel.selectedRatings
        detailVC.initialSelectedCategories = viewModel.selectedCategories
        detailVC.initialSelectedPrices = viewModel.selectedPrices
        detailVC.initialSelectedRatings = viewModel.selectedRatings
        detailVC.onCategoriesSelected = { [weak self]  selectedCategories in
            guard let self else { return }
            viewModel.selectedCategories = selectedCategories
            controlButtonStatus()
        }
        detailVC.onPricesSelected = { [weak self]  selectedPrices in
            guard let self else { return }
            viewModel.selectedPrices = selectedPrices
            controlButtonStatus()
        }
        detailVC.onRatingsSelected = { [weak self]  selectedRatings in
            guard let self else { return }
            viewModel.selectedRatings = selectedRatings
            controlButtonStatus()
        }
        navigationController?.pushViewController(detailVC, animated: false)
    }
}

//MARK: - Helpers
private extension FilterViewController {
    final func controlButtonStatus() {
        let count = viewModel.selectedPrices.count + viewModel.selectedRatings.count + viewModel.selectedCategories.count
        navigationItem.rightBarButtonItem?.isEnabled = count > 0 ? true : false
    }
    
    final func keepInitials() {
        viewModel.filterInitialSelectedPrices = viewModel.selectedPrices
        viewModel.filterInitialSelectedRatings = viewModel.selectedRatings
        viewModel.filterInitialSelectedCategories = viewModel.selectedCategories
    }
    
    final func returnToInitials() {
        viewModel.selectedPrices = viewModel.filterInitialSelectedPrices
        viewModel.selectedRatings = viewModel.filterInitialSelectedRatings
        viewModel.selectedCategories = viewModel.filterInitialSelectedCategories
    }
}


extension FilterViewController: FilterDelegate {
    func controlAllButtonStatus(filterCount: Int) {
        controlButtonStatus()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
