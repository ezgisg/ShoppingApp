//
//  SelectionCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import AppResources
import UIKit

//MARK: - SelectionCell
class SelectionCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var subTitleView: UIView!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var topImageView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerImage: UIImageView!
    @IBOutlet private weak var outerImage: UIImageView!
    @IBOutlet private weak var innerImage: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var seperatorView: UIView!
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionState(selected)
    }
    
    //MARK: - Configuration
    final func configureWith(text: String, isSelectionImageHidden: Bool = false, containerViewBackgroundColor: UIColor = .white, isThereSubtitle: Bool = false, subtitleText: String = "") {
        label.text = text
        topImageView.isHidden = isSelectionImageHidden
        containerView.backgroundColor = containerViewBackgroundColor
        subTitleView.isHidden = !isThereSubtitle
        subTitle.text = subtitleText
    }
}

//MARK: - Setup
private extension SelectionCell {
    final func setupUI() {
        ///To remove background view which occurs when cell selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
        
        topImageView.backgroundColor = .clear
        seperatorView.backgroundColor = .lightTextColor
        
        label.textColor = .gray
        subTitle.textColor = .lightButtonColor
        
        setCircleImage(image: outerImage, color: .white)
        setCircleImage(image: innerImage, color: .white)
        setCircleImage(image: containerImage, color: .tabbarBackgroundColor)
 
        func setCircleImage(image: UIImageView, color: UIColor) {
            image.image = .systemCircleImage
            image.tintColor = color
        }
    }
    
    final func updateSelectionState(_ selected: Bool) {
        innerImage.tintColor = selected ? .tabbarBackgroundColor : .white
        label.textColor = selected ? .black : .gray
    }
}
