//
//  CampaignCell.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import UIKit

class CampaignCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    func configureWith(imagePath: String, text: String) {
        let url = URL(string: imagePath)
        if let url {
            imageView.loadImage(with: url, cornerRadius: imageView.frame.width / 2)
        } 
        label.text = text
    }
    
    func setupUI() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
}


//https://img.freepik.com/free-vector/realistic-horizontal-sale-banner-template-with-photo_23-2149017940.jpg?t=st=1722607418~exp=1722611018~hmac=b63656a609b2f5fb775cf085a012fba137b9f25eb07ed606ebf2f594a87486a3&w=1480
//https://img.freepik.com/free-vector/horizontal-sale-banner-template_23-2148897327.jpg?t=st=1722607465~exp=1722611065~hmac=282136df66ebedf70b7a168bceeb822a3105adfeae5a048c76db80364b4a8647&w=1800
//https://img.freepik.com/free-vector/flat-valentine-s-day-horizontal-sale-banner-template_23-2149998309.jpg?t=st=1722607501~exp=1722611101~hmac=a9e26647b3efa30776df6ac27b3b66e6796922e600552122f782faf291d63b45&w=1800
//https://img.freepik.com/free-vector/flat-valentines-day-celebration-horizontal-sale-banner-template_23-2150019290.jpg?t=st=1722607580~exp=1722611180~hmac=bbe35b1d5c7b13896ebe7dda5c22ae1e2f211ab6b92cde91286db5f1fe423fcb&w=1800
//https://img.freepik.com/free-vector/flat-horizontal-sale-banner-template-fall-season_23-2150626750.jpg?t=st=1722607603~exp=1722611203~hmac=e62a7bcf1dbabda483e983c0d5300b692875c70fabd298500d9ab5cabc271c03&w=1800
//https://img.freepik.com/free-vector/flat-social-media-cover-template-autumn-celebration_23-2149521871.jpg?t=st=1722607658~exp=1722611258~hmac=daee2b7bed7a3ae8ed744c5f5ea1e103371fb9b0cc094dae3583f4e400f3c062&w=1800
//https://img.freepik.com/free-vector/flat-horizontal-sale-banner-template-fall-season-celebration_23-2150713493.jpg?t=st=1722607747~exp=1722611347~hmac=a8791fc0d631dc4c8e6f01513d86584191fe46632b492881d383dccf05b52cba&w=1800
//https://img.freepik.com/free-vector/flat-floral-spring-horizontal-sale-banner-template_23-2150140144.jpg?t=st=1722607821~exp=1722611421~hmac=2a9481393cbd58493f062f24e1aa00f0281569b980f7533a377ab18a5e600108&w=1800


//https://img.freepik.com/free-vector/sale-promotion-ad-poster-design-template_53876-57883.jpg?t=st=1722607923~exp=1722611523~hmac=d107feb3f0f99479cf52442fa98fc3b97eacc226045065dbc4727c4e2e3dc1ca&w=996
//https://img.freepik.com/free-vector/online-shop-neon-sign_1262-19608.jpg?t=st=1722607963~exp=1722611563~hmac=4dec06d45ba770bd6be5ca53c24227bef3b0adc5340bc63b03defc797e71cba4&w=996
//https://img.freepik.com/free-vector/flat-autumn-sale-background_23-2149093902.jpg?t=st=1722607998~exp=1722611598~hmac=aa6c5e69cf93d6cad7915eba3ef9c1346c829e03a49851ae9d49a8137a7709fc&w=996
//https://img.freepik.com/free-vector/abstract-colorful-sales-banner_23-2148335500.jpg?t=st=1722608050~exp=1722611650~hmac=4befebec350841050797d9d655193a586b932e5eecf8786cd994dd58c2244544&w=996
//https://img.freepik.com/free-psd/3d-icon-super-sales_23-2150100451.jpg?t=st=1722608210~exp=1722611810~hmac=56f3f4aebb3d62aeab40957d0c8b7533232973a0ba0fe1cb090f16d5a5281aa2&w=996
//https://img.freepik.com/free-vector/social-media-marketing-mobile-phone-concept_23-2148430940.jpg?t=st=1722608259~exp=1722611859~hmac=4ba50a171631a6a3a5ea3bde61eec6deed5a12e16318ac6c9e8687943fc274d8&w=996
