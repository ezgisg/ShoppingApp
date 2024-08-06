//
//  ProductListViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import UIKit

// MARK: - ProductListViewController
class ProductListViewController: UIViewController {

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Module init
   public init() {
       super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}
