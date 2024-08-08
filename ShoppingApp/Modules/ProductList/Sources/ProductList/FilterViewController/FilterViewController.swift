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
class FilterViewController: BaseViewController {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Module Components
    private var viewModel = FilterViewModel()
    
    var categories: [CategoryResponseElement] = []
    var selectedCategories: Set<CategoryResponseElement> = []
    
    var onCategoriesSelected: ((Set<CategoryResponseElement>) -> Void)?
    
       // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        print(FilterOption.allCases.map { $0.stringValue })
  
    }
    
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
    }
    
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle(nil, for: .normal)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupCustomRightButton() {
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Temizle", for: .normal)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
      
    //TODO: Filtreleme yoksa alert göstermeden doğrudan geriye dönecek
      @objc private func didTapBackButton() {
          showAlert(title: "Filtrelemeden Çıkış", message: "Filtreleri silmek istediğine emin misin? Silersen seçimin geçerli olmayacak.", buttonTitle: "Sil", showCancelButton: true, cancelButtonTitle: "Vazgeç") {
              self.navigationController?.popViewController(animated: true)
              self.navigationController?.navigationBar.backgroundColor = .clear
          }

      }
    //TODO: filtreleme yoksa button pasif olacak
    @objc private func didTapRightButton() {
     print("Filtreleme temizlendi")
    }

}


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
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelectionCell.self, for: indexPath)
        let option = FilterOption.allCases[indexPath.row]
        switch option {
        case .rating:
            cell.configureWith(text: option.stringValue, isSelectionImageHidden: true, containerViewBackgroundColor: .clear)
        case .price:
            cell.configureWith(text: option.stringValue, isSelectionImageHidden: true, containerViewBackgroundColor: .clear)
        case .category:
            var isThereSubtitle = false
            var subtitleText = ""
            var text = option.stringValue
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
