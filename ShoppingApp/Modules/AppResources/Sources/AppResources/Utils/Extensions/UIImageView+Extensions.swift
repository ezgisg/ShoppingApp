//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 2.08.2024.
//

import Foundation
import UIKit.UIImageView
import Kingfisher

///To load image from url with KF
public extension UIImageView {
    func loadImage(with url: URL, cornerRadius: CGFloat = 10) {
        kf.indicatorType = .activity
        contentMode = .scaleToFill
        layer.cornerRadius = cornerRadius
        kf.setImage(with: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                image = data.image
            case .failure(let error):
                debugPrint("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                //TODO: image değiştirilecek
                image = .systemCircleImage
            }
        }
    }
}

