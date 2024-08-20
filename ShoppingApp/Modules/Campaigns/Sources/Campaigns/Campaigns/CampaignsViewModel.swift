//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 19.08.2024.
//

import AppResources
import Foundation

protocol CampaignsViewModelProtocol: AnyObject {
    var campaignData: [Item]? { get }
    func loadCampaignData(for language: String)
}

protocol CampaignsViewModelDelegate: AnyObject {
    func reloadData()
}

final class CampaignsViewModel {
    weak var delegate: CampaignsViewModelDelegate?
    var campaignData: [Item]? = []
}


extension CampaignsViewModel: CampaignsViewModelProtocol {
    func loadCampaignData(for language: String) {
        guard let url = AppResources.bundle.url(forResource: "Banner", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let bannerDataList = try JSONDecoder().decode([BannerData].self, from: data)
            
            if let bannerData = bannerDataList.first(where: { $0.language == language }) {
                let campaignItems = bannerData.elements?.first { $0.type == "campaign" }?.items
                if let campaignItems, !campaignItems.isEmpty {
                    campaignData = campaignItems
                    delegate?.reloadData()
                }
            }
        } catch {
            print("JSON verisi işlenirken hata oluştu: \(error)")
        }
    }
}
