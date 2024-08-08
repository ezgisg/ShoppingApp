//
//  FilterDetailViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 8.08.2024.
//

import AppResources
import Base
import UIKit

class FilterDetailViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var filterOptionType: FilterOption
    var categories: [CategoryResponseElement] = []
    var selectedCategories: Set<CategoryResponseElement> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()

    }
    
    // MARK: - Module init
    public init(filterOptionType: FilterOption) {
        self.filterOptionType = filterOptionType
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
    }
    
}

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
    }
    
    final func setupTableView() {
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
            cell.configureWith(text: RatingOption.allCases[indexPath.row].stringValue)
        case .price:
            cell.configureWith(text: PriceOption.allCases[indexPath.row].stringValue)
        case .category:
            cell.configureWith(text: "")
        }
        
        return cell
    }
    
}
