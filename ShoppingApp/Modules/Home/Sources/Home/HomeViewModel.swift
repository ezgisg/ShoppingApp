//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Foundation
import Network

// MARK: - HomeViewModelProtocol
protocol HomeViewModelProtocol: AnyObject {
    var campaignMessages : [String] { get }
    
    func loadBannerData(for language: String)
    func loadCategoryImagesPath() -> [String:String]
    func fetchCategories()
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
    func getBannerData(bannerData: BannerData)
    func getCategories(categories: [String])
}

// MARK: - HomeViewModel
final class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    private var service: ShoppingServiceProtocol
    
    init(service: ShoppingServiceProtocol = ShoppingService()) {
        self.service = service
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    var campaignMessages: [String] {
        return [
            L10nGeneric.CampaignMessages.CampaignMessages1.localized(),
            L10nGeneric.CampaignMessages.CampaignMessages2.localized(),
            L10nGeneric.CampaignMessages.CampaignMessages3.localized(),
            L10nGeneric.CampaignMessages.CampaignMessages4.localized(),
            L10nGeneric.CampaignMessages.CampaignMessages5.localized(),
            L10nGeneric.CampaignMessages.CampaignMessages6.localized(),
        ]
    }
    
    func loadCategoryImagesPath() -> [String:String] {
        ["electronics": "https://img.freepik.com/free-photo/top-view-male-self-care-items_23-2150347090.jpg?t=st=1722838396~exp=1722841996~hmac=9fc0d41bb04da998b971f05dd911f37beb6a950f753811d37610fe76459d930a&w=1800",
         "jewelery": "https://img.freepik.com/free-photo/luxury-shine-diamonds-digital-art_23-2151695039.jpg?t=st=1722838346~exp=1722841946~hmac=45007107b4025c5c98956612e18dddcf1144b82aa5be6830dafba16cf452b59f&w=1800",
         "men's clothing": "https://img.freepik.com/free-photo/fast-fashion-concept-with-full-clothing-store_23-2150871146.jpg?t=st=1722838496~exp=1722842096~hmac=f4d1f0e15c257d3be3cf0892dacb934e99ec29aaa2abfc64b7efd950219abea3&w=1800",
         "women's clothing": "https://img.freepik.com/free-photo/elegant-fashion-collection-hanging-modern-boutique-generated-by-ai_188544-24625.jpg?t=st=1722838793~exp=1722842393~hmac=810a1e19bd1820b9888669668e01e0895ef3a8c049e9f9c22a047fa192f77b00&w=1800"]
    }
    
    func loadBannerData(for language: String) {
        guard let url = Bundle.module.url(forResource: "Banner", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let bannerDataList = try JSONDecoder().decode([BannerData].self, from: data)
            if let bannerData = bannerDataList.first(where: { $0.language == language }) {
                print(bannerData)
                delegate?.getBannerData(bannerData: bannerData)
            }
        } catch {
            return
        }
    }
    
    func fetchCategories() {
        service.fetchCategories(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.delegate?.getCategories(categories: data)
            case .failure(_):
                debugPrint("Kategoriler yüklenemedi")
            }
        })
    }
}
