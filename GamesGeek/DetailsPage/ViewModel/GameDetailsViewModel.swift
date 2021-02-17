//
//  GameDetailsViewModel.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 15.02.2021.
//

import Foundation

class GameDetailsViewModel {

    var onSuccessResponse: (()->())?
    var onErrorResponse: ((String)->())?
    
    var game: GameDetails?

    func fetchData(id: Int) {
        let url = URL(string: "https://api.rawg.io/api/games/\(id)")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(GameDetails.self, from: data)
                            self.game = response
                            self.onSuccessResponse?()
                        } catch let error {
                            self.onErrorResponse?("Not a Valid JSON Response with Error : \(error)")
                        }
                    } else {
                        self.onErrorResponse?("HTTP Status: \(response.statusCode)")
                    }
                }
            }
        }
        task.resume()
    }
}
