//
//  RegisterViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 29.07.2024.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var checkBoxView: CheckBoxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         checkBoxView.configureWithBoldText(
             initialImage: .welcomeImage,
             secondImage: .checkoutImage,
             fullText: "Açık Rıza Metnini lütfen okuyun",
             boldPart: "lütfen",
             target: self,
             action: #selector(didTapBoldText(_:))
         )
     }

     @objc private func didTapBoldText(_ sender: UITapGestureRecognizer) {
         let label = sender.view as! UILabel
         let boldPartRange = (label.text! as NSString).range(of: "lütfen")
         
         if label.didTapAttributedTextInLabel(label, inRange: boldPartRange, tapGesture: sender) {
             let signInVC = SignInViewController()
             navigationController?.pushViewController(signInVC, animated: true)
         } else {
        
             checkBoxView.topButton.sendActions(for: .touchUpInside)
         }
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
    func setBoldAndClickableText(fullText: String, clickablePart: String, target: Any, action: Selector) {
        let attributedString = NSMutableAttributedString(string: fullText)
        let clickableRange = (fullText as NSString).range(of: clickablePart)
        
        // Set the bold and clickable attributes
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)], range: clickableRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: clickableRange)
        
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    func didTapAttributedTextInLabel(_ label: UILabel, inRange targetRange: NSRange, tapGesture: UITapGestureRecognizer) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = tapGesture.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
