//
//  SelectionCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//

import AppResources
import UIKit

class SelectionCell: UITableViewCell {


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
        containerView.backgroundColor = .white
        
        containerImage.image = .systemCircleImage
        containerImage.tintColor = .tabbarBackgroundColor
        
        outerImage.image = .systemCircleImage
        outerImage.tintColor = .white

        innerImage.image = .systemCircleImage
        innerImage.tintColor = .white
        
        label.textColor = .black
    }
    
    public func updateSelectionState(_ selected: Bool) {
          if selected {
              innerImage.tintColor = .tabbarBackgroundColor
          } else {
              innerImage.tintColor = .white
          }
      }
    
    final func configureWith(text: String) {
        label.text = text
    }
}
