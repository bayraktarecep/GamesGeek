//
//  GameDetails.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 15.02.2021.
//

import Foundation

struct GameDetails: Codable {
    let name: String?
    let released: Date?
    let rating: Float?
    let ratingsCount: Int?
    let descriptionRaw: String?
    let backgroundImage: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String?.self, forKey: .name)
        let dateString = try container.decode(String?.self, forKey: .released) ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        released = date
        rating = try container.decode(Float?.self, forKey: .rating)
        ratingsCount = try container.decode(Int?.self, forKey: .ratingsCount)
        descriptionRaw = try container.decode(String?.self, forKey: .descriptionRaw)
        backgroundImage = try container.decode(String?.self, forKey: .backgroundImage)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case rating
        case released
        case ratingsCount = "ratings_count"
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
    }
}
