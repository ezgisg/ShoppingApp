//
//  DescriptionCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 22.08.2024.
//

import UIKit

class DescriptionCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    final func configureWith(text: String) {
        textLabel.text = text
    }
    
}
