//
//  HomeViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import UIKit

public class HomeViewController: UIViewController {

    
    // MARK: - Module
    public static var module = Bundle.module
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLanguage = Localize.currentLanguage()
        
        let selectedLanguage = currentLanguage.uppercased()
        loadBannerData(for: selectedLanguage) { bannerData in
            if let data = bannerData {
                print("Banner Data for \(selectedLanguage): \(data)")
            } else {
                print("No data available for \(selectedLanguage)")
            }
        }
     
    }
    
    func loadBannerData(for language: String, completion: @escaping (BannerData?) -> Void) {
        guard let url = Bundle.module.url(forResource: "Banner", withExtension: "json") else {
            print("Banner.json file not found")
            completion(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let bannerDataList = try JSONDecoder().decode([BannerData].self, from: data)
            
            // Find the data for the requested language
            if let bannerData = bannerDataList.first(where: { $0.language == language }) {
                completion(bannerData)
            } else {
                print("No data found for language: \(language)")
                completion(nil)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
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
