//
//  FavoritesTableViewCell.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 16.02.2021.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadWith(data: FavoritesModel) {
        
        let url = data.backgroundImage
        gameImage.kf.setImage(with: URL(string: url ?? ""))
        
        titleLabel.text = data.name
        
        releaseDateLabel.text = "\(data.rating ?? 0) | \(data.released?.toString(format: "d MMM, yyyy") ?? "No Date.")"
        
    }


}
