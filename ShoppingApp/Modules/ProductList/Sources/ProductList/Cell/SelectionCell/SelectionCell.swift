//
//  SelectionCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import AppResources
import UIKit

class SelectionCell: UITableViewCell {


    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var topImageView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var containerImage: UIImageView!
    @IBOutlet private weak var outerImage: UIImageView!
    @IBOutlet private weak var innerImage: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
         updateSelectionState(selected)
     }
    
    private func setupUI() {
        //To remove background view which occurs when cell selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    
        topImageView.backgroundColor = .white
        
        containerImage.image = .systemCircleImage
        containerImage.tintColor = .tabbarBackgroundColor
        
        outerImage.image = .systemCircleImage
        outerImage.tintColor = .white

        innerImage.image = .systemCircleImage
        innerImage.tintColor = .white
        
        label.textColor = .gray
        seperatorView.backgroundColor = .lightTextColor
        
        subTitle.textColor = .lightButtonColor
    }
    
    public func updateSelectionState(_ selected: Bool) {
          if selected {
              innerImage.tintColor = .tabbarBackgroundColor
              label.textColor = .black
          } else {
              innerImage.tintColor = .white
              label.textColor = .gray
          }
      }
    
    final func configureWith(text: String, isSelectionImageHidden: Bool = false, containerViewBackgroundColor: UIColor = .white, isThereSubtitle: Bool = false, subtitleText: String = "") {
        label.text = text
        topImageView.isHidden = isSelectionImageHidden
        containerView.backgroundColor = containerViewBackgroundColor
        subTitleView.isHidden = !isThereSubtitle
        subTitle.text = subtitleText
    }
}
