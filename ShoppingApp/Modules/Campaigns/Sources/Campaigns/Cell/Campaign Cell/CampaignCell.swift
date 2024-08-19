//
//  CampaignCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 19.08.2024.
//

import AppResources
import UIKit

//MARK: - UICollectionViewCell
class CampaignCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var seperatorView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet weak var horizontalSeperatorView: UIView!
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    func configureWith(data: Item) {
        leftLabel.text = data.name
        bottomLabel.text = data.name
        guard let url = URL(string: data.image ?? "") else { return imageView.image = .noImage }
        imageView.loadImage(with: url, cornerRadius: 0, contentMode: .scaleAspectFill)
    }
    
}

//MARK: - Setups
private extension CampaignCell {
    final func setups() {
        setupLeftViewGradient()
        leftView.backgroundColor = .black
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.tabbarBackgroundColor.withAlphaComponent(0.5).cgColor
        containerView.layer.borderWidth = 4
        containerView.clipsToBounds = true
        horizontalSeperatorView.backgroundColor = .lightDividerColor
        seperatorView.backgroundColor = .lightDividerColor
        leftLabel.textColor = .white
        bottomLabel.textColor = .tabbarBackgroundColor
        
    }
    
    
    func setupLeftViewGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.3).cgColor,
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.5).cgColor,
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.9).cgColor,
            UIColor.tabbarBackgroundColor.cgColor,
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.9).cgColor,
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.5).cgColor,
            UIColor.tabbarBackgroundColor.withAlphaComponent(0.3).cgColor
        ]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           gradientLayer.frame = leftView.bounds
           leftView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
