//
//  FilterCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 6.08.2024.
//

import UIKit

//MARK: - FilterCell
class FilterCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var label: UILabel!
    
    var isSelectedCell: Bool = false {
        didSet {
            containerView.backgroundColor = isSelectedCell ? .lightGray : .white
        }
    }

    //MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

}

//MARK: - Setup
private extension FilterCell {
    func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        label.textColor = .textColor
    }
}

//MARK: - Configure
extension FilterCell {
    func configureWith(text: String) {
        label.text = text
    }
}
