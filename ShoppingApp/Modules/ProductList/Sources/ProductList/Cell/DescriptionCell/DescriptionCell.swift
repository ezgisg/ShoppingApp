//
//  DescriptionCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.08.2024.
//

import UIKit

//MARK: - DescriptionCell
class DescriptionCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var textLabel: UILabel!
    
    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Configuration
    final func configureWith(text: String) {
        textLabel.text = text
    }
}
