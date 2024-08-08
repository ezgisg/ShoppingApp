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
    
    
       // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedColor
        ]
        containerView.backgroundColor = .tabbarBackgroundColor.withAlphaComponent(1)
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
}
