//
//  MainTableViewCell.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 15.02.2021.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    //MARK: TableView Cell Outlets
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingandreleaseLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadWith(data: Game) {
        
        let url = data.backgroundImage
        gameImage.kf.setImage(with: URL(string: url ?? ""))
        
        titleLabel.text = data.name
        
        ratingandreleaseLabel.text = "\(data.rating ?? 0) | \(data.released?.toString(format: "d MMM, yyyy") ?? "No Date.")"
        
    }
    
}

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
