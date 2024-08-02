//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import AppResources
import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func loadBannerData(for language: String)
}

protocol HomeViewModelDelegate: AnyObject {
    func getBannerData(bannerData: BannerData)
}

final class HomeViewModel {
    var delegate: HomeViewModelDelegate?
}


extension HomeViewModel: HomeViewModelProtocol {
    func loadBannerData(for language: String) {
        guard let url = Bundle.module.url(forResource: "Banner", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let bannerDataList = try JSONDecoder().decode([BannerData].self, from: data)
            if let bannerData = bannerDataList.first(where: { $0.language == language }) {
                delegate?.getBannerData(bannerData: bannerData)
            }
        } catch {
            return
        }
    }
    
}
