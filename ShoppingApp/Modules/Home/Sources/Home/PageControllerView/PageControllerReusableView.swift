//
//  PageControllerReusableView.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import UIKit

class PageControllerReusableView: UICollectionReusableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.backgroundColor = .clear
        pageController.backgroundColor = .clear
        pageController.currentPageIndicatorTintColor = .textColor
        pageController.pageIndicatorTintColor = .lightTextColor
    }

    func configureCurrentPage(with currentPage: Int) {
        pageController.currentPage = currentPage
    }
    
    func configureNumberOfPage(with numberOfPages: Int) {
        pageController.numberOfPages = numberOfPages
        pageController.currentPage = 0
    }
    
}
