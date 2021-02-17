//
//  MainCarouselCollectionViewCell.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 14.02.2021.
//

import UIKit
import Kingfisher

class MainCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carouselImageView: UIImageView!
    
    func loadImages(data: Game) {
        let url = data.backgroundImage
        carouselImageView.kf.setImage(with: URL(string: url ?? ""))
    }
}
