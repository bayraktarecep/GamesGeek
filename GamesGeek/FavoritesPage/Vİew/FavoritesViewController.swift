//
//  FavoritesViewController.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 17.02.2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    lazy var favoritesProvider: FavoritesViewModel = { return FavoritesViewModel() }()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyFavorites: UIView!
    
    private var favorites: [FavoritesModel] = []
    private var id = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 110
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesProvider.getAllFavorites(completion: { favorites in
            DispatchQueue.main.async {
                self.favorites = favorites
                self.emptyFavorites.isHidden = !favorites.isEmpty
                self.tableView.reloadData()
            }
        })
    }
    

}

//MARK: - Table view data source

extension FavoritesViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritesTableViewCell
        
        cell.loadWith(data: favorites[indexPath.row])
        return cell
    }
    
}

//MARK: - Table view delegate

extension FavoritesViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController
        vc?.id = Int(Int32(favorites[indexPath.row].id!))
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
