//
//  HomeViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import UIKit

public class HomeViewController: UIViewController {

    
    private var viewModel = HomeViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        let currentLanguage = Localize.currentLanguage().uppercased()
        viewModel.loadBannerData(for: currentLanguage)
        
    }
    


    // Example usage
    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func getBannerData(bannerData: BannerData) {
        print(bannerData)
    }
}
