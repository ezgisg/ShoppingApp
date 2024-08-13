//
//  CartViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 12.08.2024.
//

import UIKit

public class CartViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var paymentButton: UIButton!
    
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var detailStack: UIStackView!
    @IBOutlet weak var orderSummaryLabelOfDetailStack: UILabel!
    @IBOutlet weak var detailLabelOfDetailStack: UILabel!
    @IBOutlet weak var sumLabelOfDetailStack: UILabel!
    @IBOutlet weak var sumCountLabelOfDetailStack: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountCountLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalCountLabel: UILabel!
    @IBOutlet weak var cargoFeeLabel: UILabel!
    @IBOutlet weak var cargoFeeCountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var miniDetailStack: UIStackView!
    @IBOutlet weak var orderSummaryLabelOfMiniDetailStack: UILabel!
    @IBOutlet weak var detailLabelOfMiniDetailStack: UILabel!
    
    @IBOutlet weak var sumStack: UIStackView!
    @IBOutlet weak var sumLabelofSumStack: UILabel!
    @IBOutlet weak var sumLabelCountofSumStack: UILabel!
    
    @IBOutlet weak var sumStackWithDiscount: UIStackView!
    @IBOutlet weak var totalDiscountLabel: UILabel!
    @IBOutlet weak var totalDiscountCountLabel: UILabel!
    @IBOutlet weak var sumLabelofSumStackWithDiscount: UILabel!
    @IBOutlet weak var sumLabelCountofSumStackWithDiscount: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Module init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}
