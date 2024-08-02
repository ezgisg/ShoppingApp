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
//        setupView()
        // Initialization code
    }
    
    private func setupView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
    }

    func configure(with numberOfPages: Int, currentPage: Int) {
        pageController.numberOfPages = numberOfPages
        pageController.currentPage = currentPage
    }
    
}
