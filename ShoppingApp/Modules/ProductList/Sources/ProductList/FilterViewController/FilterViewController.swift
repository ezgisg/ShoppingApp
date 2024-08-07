//
//  FilterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import Base
import UIKit


// MARK: - FilterViewController
class FilterViewController: BaseViewController {

    
    // MARK: - Module Components
    private var viewModel = FilterViewModel()
    
    
       // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .yellow
        print(FilterOption.allCases.map { $0.stringValue })
        setupCustomBackButton()
    }
    
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomBackButton() {
          let backButton = UIButton(type: .system)
          backButton.setTitle("X", for: .normal)
          backButton.setTitleColor(.purple, for: .normal)
          backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

          let backBarButtonItem = UIBarButtonItem(customView: backButton)
          navigationItem.leftBarButtonItem = backBarButtonItem
      }
      
      @objc private func didTapBackButton() {
          showAlert(title: "son", message: "çıkıyorsunuz", buttonTitle: "ok", showCancelButton: true) {
              self.navigationController?.popViewController(animated: true)
              self.navigationController?.navigationBar.backgroundColor = .clear
          }

      }

}


