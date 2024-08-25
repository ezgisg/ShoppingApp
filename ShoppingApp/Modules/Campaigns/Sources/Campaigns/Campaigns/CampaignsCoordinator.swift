//
//  CampaignsCoordinator.swift
//
//
//  Created by Ezgi Sümer Günaydın on 25.08.2024.
//

import AppResources
import Base
import UIKit

// MARK: - CampaignsRouter
public protocol CampaignsRouter: AnyObject {
    
}

// MARK: - CampaignsCoordinator
final public class CampaignsCoordinator: BaseCoordinator {
    // MARK: - Publics
    public var delegate: CampaignsRouter?

    // MARK: - Start
    public override func start() {
        let controller = CampaignsViewController(
            viewModel: CampaignsViewModel(),
            coordinator: self
        )

        navigationController.setViewControllers([controller], animated: false)
    }

    // MARK: - Routing Methods
    public func routeToDetail(with data: Item) {
        let detailVC = CampaignDetailViewController(data: data)
        detailVC.modalPresentationStyle = .popover
        detailVC.modalTransitionStyle = .crossDissolve
        navigationController.present(detailVC, animated: true, completion: nil)
    }
}
