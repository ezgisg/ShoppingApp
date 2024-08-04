//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Foundation
import Network

protocol HomeViewModelProtocol: AnyObject {
    func loadBannerData(for language: String)
    func loadCategoryImagesPath() -> [String:String]
    func fetchCategories()
}

protocol HomeViewModelDelegate: AnyObject {
    func getBannerData(bannerData: BannerData)
    func getCategories(categories: [String])
}

final class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    private var service: ShoppingServiceProtocol

      init(service: ShoppingServiceProtocol = ShoppingService()) {
          self.service = service
      }
}


extension HomeViewModel: HomeViewModelProtocol {
    func loadCategoryImagesPath() -> [String:String] {
        ["electronics": "https://img.freepik.com/free-photo/tablet-with-headphones-rest_23-2148149492.jpg?t=st=1722765161~exp=1722768761~hmac=8049310aff95d803fdb23d76d530622e9c057881bd09a2848329595cd8061495&w=1480",
         "jewelery":"https://img.freepik.com/free-photo/hand-gloves-takes-exclusive-rings-showcase-luxury-jewelry-store_613910-20954.jpg?t=st=1722762468~exp=1722766068~hmac=5d49006cd88c23266d22d073d92d8e0b4b10136de6a2d559532e98a4d6cb6914&w=1480",
         "men's clothing":"https://img.freepik.com/free-photo/top-view-composition-different-traveling-elements_23-2148884942.jpg?t=st=1722762553~exp=1722766153~hmac=8560009a1be38d40d27272aad3e0aeceec4ae4c142788fb5f2d70346ee5e5ff6&w=1480",
         "women's clothing":"https://img.freepik.com/free-photo/flat-lay-woman-style-accessories-red-knitted-sweater-checkered-shirt-denim-jeans-black-leather-boots-hat-autumn-fashion-trend-view-from-vintage-photo-camera-traveler-outfit_285396-5104.jpg?t=st=1722762594~exp=1722766194~hmac=7c5d30ee7cbb27529cfd898d17e880266efc067f93d5e528c04f6b9072257f20&w=1480"]
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
    
    //TODO: kategorilere uygun resimler eklenecek ayrı bir json ile beraber alınacak
    func fetchCategories() {
        service.fetchCategories(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.delegate?.getCategories(categories: data)
            case .failure(_):
                break
            }
        })
    }
    
    
}
