//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 5.09.2024.
//

import AppResources
import Foundation
@testable import Home

final class HomeViewModelDelegateMock: HomeViewModelDelegate {
    
    var isBannerDataLoaded = false
    var banner: BannerData? = nil
    var calledCategories: [String]?
    
    func getBannerData(bannerData: BannerData) {
        isBannerDataLoaded = true
        banner = bannerData
    }
    
    func getCategories(categories: [String]) {
        calledCategories = categories
    }
    
}
