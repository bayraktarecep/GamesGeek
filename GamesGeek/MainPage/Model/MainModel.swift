//
//  MainModel.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 14.02.2021.
//

import Foundation

struct Response: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    var results: [Game] = []
}

struct Game: Codable {
    
    let id: Int?
    let name: String?
    let released: Date?
    let rating: Float?
    var ratingsCount: Int?
    var backgroundImage: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
        let dateString = try container.decode(String?.self, forKey: .released) ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        released = date
        rating = try container.decode(Float?.self, forKey: .rating)
        ratingsCount = try container.decode(Int?.self, forKey: .ratingsCount)
        backgroundImage = try container.decode(String?.self, forKey: .backgroundImage)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case rating
        case ratingsCount = "ratings_count"
        case backgroundImage = "background_image"
    }
}
