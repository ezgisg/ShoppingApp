//
//  PageViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import AppResources
import Base
import UIKit

class PageViewController: BaseViewController {

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var sendedImage: UIImage?
    var sendedTitle: String?
    var sendedDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(sendedImage: UIImage, sendedTitle: String, sendedDescription: String) {
         self.sendedImage = sendedImage
         self.sendedTitle = sendedTitle
         self.sendedDescription = sendedDescription
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
}

extension PageViewController {
    final func setupUI() {
        image.image = sendedImage
        image.contentMode = .scaleAspectFit
        
        titleLabel.text = sendedTitle
        titleLabel.textColor = .textColor
        
        descriptionLabel.text = sendedDescription
        descriptionLabel.textColor = .textColor
        
        view.backgroundColor = .backgroundColor
    }
}
