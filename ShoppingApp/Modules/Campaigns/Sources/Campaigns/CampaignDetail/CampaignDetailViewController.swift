//
//  CampaignDetailViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 20.08.2024.
//

import AppResources
import UIKit

//MARK: - CampaignDetailViewController
class CampaignDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var screenTitle: UILabel!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var seperatorView: UIView!
    
    public var data: Item?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Module init
    init(data: Item) {
        self.data = data
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    private func setup() {
        screenTitle.text = L10nGeneric.campaignDetails.localized()
        screenTitle.textColor = .black
        topView.backgroundColor = .gray
        seperatorView.backgroundColor = .lightDividerColor
        topView.layer.cornerRadius = 4

        titleLabel.text = data?.name
        detailLabel.text = data?.subheading
        
        titleLabel.textColor = .black
        detailLabel.textColor = .black
        
        guard let url = URL(string: data?.image ?? "") else { return imageView.image = .noImage }
        imageView.loadImage(with: url, cornerRadius: 0, contentMode: .scaleAspectFill)
    }
}
