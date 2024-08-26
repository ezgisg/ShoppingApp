//
//  FilterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import AppResources
import Base
import UIKit

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
        setupUI()
        setupTableView()
        viewModel.keepInitials(isDetailScreen: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ///viewModel.filterDelegate = self added here because filterVC and filterDetailVC uses same delegate
        viewModel.filterDelegate = self
        controlButtonStatus()
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

//MARK: - Setups
private extension FilterViewController {
    final func setupUI() {
        self.title = L10nGeneric.filter.localized()
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
        button.setTitle(L10nGeneric.list.localized(), for: .normal)
        
        setupCustomBackButton()
        setupCustomRightButton()
        controlButtonStatus()
    }
    
    final func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
        rightButton.setTitle(L10nGeneric.clean.localized(), for: .normal)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
}

//TODO: image ları asset olarak ekle
//MARK: - Actions
private extension FilterViewController {
    @objc final func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc final func didTapBackButton() {
        let isDifferentFromInitials = viewModel.isDifferentFromInitialsOnFilter
        guard isDifferentFromInitials else { return dismissView() }
        showAlert(title: L10nGeneric.FilterWarnings.clean.localized(), message: L10nGeneric.FilterWarnings.cleanMessages.localized(), buttonTitle: L10nGeneric.delete.localized(), showCancelButton: true, cancelButtonTitle: L10nGeneric.abort.localized()) {  [weak self] in
            guard let self else { return }
            viewModel.returnToInitials(isDetailScreen: false)
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
        
        func configureCell(for option: FilterOption, selectedItems: [String], text: String) {
            ///To manage show the selections on subtitle and show selection count
            let isThereSubtitle = !selectedItems.isEmpty
            let subtitleText = selectedItems.joined(separator: ", ")
            let finalText = isThereSubtitle ? "\(text) (\(selectedItems.count))" : text
            cell.configureWith(text: finalText, isSelectionImageHidden: true, containerViewBackgroundColor: .clear, isThereSubtitle: isThereSubtitle, subtitleText: subtitleText)
        }
        
        switch option {
        case .rating:
            let selectedRatings = viewModel.selectedRatings.map { $0.stringValue }
            configureCell(for: option, selectedItems: selectedRatings, text: option.stringValue)
        case .price:
            let selectedPrices = viewModel.selectedPrices.map { $0.stringValue }
            configureCell(for: option, selectedItems: selectedPrices, text: option.stringValue)
        case .category:
            let selectedCategories = viewModel.selectedCategories.map { $0.value ?? "N/A" }
            configureCell(for: option, selectedItems: selectedCategories, text: option.stringValue)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = FilterOption.allCases[indexPath.row]
        let detailVC = FilterDetailViewController(filterOptionType: option, viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: false)
    }
}

//MARK: - Helpers
private extension FilterViewController {
    final func controlButtonStatus() {
        let count = viewModel.filterCount
        navigationItem.rightBarButtonItem?.isEnabled = count > 0 ? true : false
        tableView.reloadData()
    }
}

//MARK: - FilterDelegate
extension FilterViewController: FilterDelegate {
    func controlAllButtonStatus() {
        controlButtonStatus()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
