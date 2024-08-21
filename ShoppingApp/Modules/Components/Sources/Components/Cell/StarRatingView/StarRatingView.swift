//
//  StarRatingView.swift
//
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import AppResources
import Foundation
import UIKit

public class StarRatingView: UIView {
    
    private let maxRating = 5.0
    private var rating: Double = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var stars: [UIImageView] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        loadNibContent()
        setupStars()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        loadNibContent()
        setupStars()
    }

    private func setupStars() {
        for _ in 0..<Int(maxRating) {
            let star = UIImageView()
            star.image = UIImage(systemName: "star.fill")
            star.tintColor = .gray
            stars.append(star)
            addSubview(star)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let size = bounds.width
        let spacing: CGFloat = 5.0
        let starSize = (size - spacing * maxRating) / maxRating
        for (index, star) in stars.enumerated() {
            let xPosition = CGFloat(index) * (starSize + spacing)
            let yPosition = (bounds.height - starSize) / 2
            star.frame = CGRect(x: xPosition, y: yPosition, width: starSize, height: starSize)
            star.contentMode = .scaleAspectFit
            updateStar(star, at: index)
        }
    }

    private func updateStar(_ star: UIImageView, at index: Int) {
        let starLayer = CALayer()
        starLayer.frame = star.bounds
        starLayer.contents = UIImage(systemName: "star.fill")?.cgImage
        star.layer.mask = starLayer

        let filledRatio = max(0, min(1, rating - Double(index)))
        star.tintColor = .gray
        star.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        if filledRatio > 0 {
            let fillLayer = CALayer()
            fillLayer.frame = CGRect(x: 0, y: 0, width: star.bounds.width * CGFloat(filledRatio), height: star.bounds.height)
            fillLayer.backgroundColor = UIColor.systemYellow.cgColor
            star.layer.addSublayer(fillLayer)
        }
        
    }

    public func setRating(_ rating: Double) {
        self.rating = rating
    }
}
