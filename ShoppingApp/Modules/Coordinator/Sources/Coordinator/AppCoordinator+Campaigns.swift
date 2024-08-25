//
//  AppCoordinator+Campaigns.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import Campaigns
import Foundation

public extension AppCoordinator {
    func routeToCampaignDetail(
        with item: Item,
        _ from: BaseCoordinator
    ) {
        let coordinator = CampaignsCoordinator(from.navigationController)
        
        coordinator.routeToDetail(with: item)
    }
}
