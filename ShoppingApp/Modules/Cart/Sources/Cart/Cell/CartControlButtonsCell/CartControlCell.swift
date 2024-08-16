//
//  CartControlCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 16.08.2024.
//

import UIKit

class CartControlCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topImageView: UIView!
    @IBOutlet private weak var containerImage: UIImageView!
    @IBOutlet private weak var outerImage: UIImageView!
    @IBOutlet private weak var innerImage: UIImageView!
    @IBOutlet private weak var selectAllLabel: UILabel!
    @IBOutlet private weak var deleteSelectedLabel: UILabel!
 
    
    var isSelectAllActive : Bool = false
    
    // MARK: - Properties
    var onSelectAllTapped: (() -> Void)?
    var onDeleteAllTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    func configureWith(selectedItemCount: Int, isSelectAllActive: Bool) {
        deleteSelectedLabel.text = "Seçilenleri Sil (\(selectedItemCount))"
        self.isSelectAllActive = isSelectAllActive
        controlSelectionStatus()
    }
    
}

extension CartControlCell {
    final func setups() {
        setupButtonsUI()
        setupTexts()
        setupBackgrounds()
        addTapGesture()
    }
    
    final func setupButtonsUI() {

        //TODO: bu buton hem sortda-hem productta var hem burada var view ortaklaştırılacak
        topImageView.backgroundColor = .clear
        containerImage.image = .systemCircleImage
        containerImage.tintColor = .tabbarBackgroundColor
        outerImage.image = .systemCircleImage
        outerImage.tintColor = .white
        innerImage.image = .systemCircleImage
    }
    
    final func setupBackgrounds() {
        containerView.backgroundColor = .lightDividerColor
    }
    
    final func setupTexts() {
        selectAllLabel.text = "Tümünü Seç"
        selectAllLabel.textColor = .black
        deleteSelectedLabel.textColor = .black
    }
    
    final func addTapGesture() {
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSelect))
        topImageView.addGestureRecognizer(selectGesture)
        topImageView.isUserInteractionEnabled = true
        
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(tappedDelete))
        deleteSelectedLabel.addGestureRecognizer(deleteGesture)
        deleteSelectedLabel.isUserInteractionEnabled = true

    }
    
}


//MARK: - Actions
private extension CartControlCell {
    @objc final func tappedSelect() {
        onSelectAllTapped?()
//        isSelectAllActive.toggle()
//        controlSelectionStatus()
    }
    
    @objc final func tappedDelete() {
        onDeleteAllTapped?()
    }
}

//MARK: - Helpers
private extension CartControlCell {
    final func controlSelectionStatus() {
        innerImage.tintColor = isSelectAllActive ? .tabbarBackgroundColor : .clear
    }
}
