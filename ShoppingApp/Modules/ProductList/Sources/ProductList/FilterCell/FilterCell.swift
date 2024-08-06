//
//  FilterCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    @IBAction func cellClicked(_ sender: Any) {
    }
    
    func configureWith(text: String) {
        label.text = text
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        label.textColor = .textColor
    }
}
