//
//  MainViewModel.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 14.02.2021.
//

import Foundation

class MainViewModel {
    
    var onSuccessResponse: (()->())?
    var onErrorResponse: ((String)->())?
    
    private var page = 1
    private var key = "9928717a26cb4a5ea950de9c6c42a76d"
    private var components = URLComponents(string: "https://api.rawg.io/api/games")!
    var games: [Game] = []
    
    func fetchData(search: String = "") {
        components.queryItems = [
            URLQueryItem(name: "key", value: String(key)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "search", value: String(search))
        ]
        
        print(components.url!)
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(Response.self, from: data)
                            self.games = response.results
                            self.onSuccessResponse?()
                            print(self.games.count)
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
