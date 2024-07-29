//
//  RegisterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import AppResources
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet weak var secondCheckBoxView: CheckBoxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBoxView.configureWith(initialImage: .browseImage, secondImage: .welcomeImage, textContent: "Deneme 123", boldContent: "123", isCheckBoxImageNeeded: false)
        secondCheckBoxView.configureWith(initialImage: .browseImage, secondImage: .welcomeImage, textContent: "Deneme 456", boldContent: "Deneme", isCheckBoxImageNeeded: true)
  
    }
    


    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


extension UILabel {
    func setBoldText(fullText: String, boldPart: String) {
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let boldRange = (fullText as NSString).range(of: boldPart)
        
        // Set the bold attributes
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)], range: boldRange)
        
        self.attributedText = attributedString
    }
}
