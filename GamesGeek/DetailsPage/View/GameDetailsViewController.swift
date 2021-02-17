//
//  GameDetailsViewController.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 15.02.2021.
//

import UIKit
import Kingfisher

class GameDetailsViewController: UIViewController {
    
    lazy var favoritesProvider: FavoritesViewModel = { return FavoritesViewModel() }()
    
    //MARK: - Outlets
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    private let viewModel = GameDetailsViewModel()
    var id = -1
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setData()
        loadData()
        setupProvider()
    }
    
    
    //MARK: - Load Data from URL
    
    func loadData() {
        viewModel.onErrorResponse = { error in
            self.showAlert(message: error)
        }
        viewModel.onSuccessResponse = {
            self.setData()
        }
        viewModel.fetchData(id: id)
    }
    
    func setData() {
        if let data = viewModel.game {
            let url = data.backgroundImage
            gameImage.kf.setImage(with: URL(string: url ?? ""))
            
            titleLabel.text = data.name
            
            detailsTextView.text = data.descriptionRaw
            
            releaseDate.text = data.released?.toString(format: "d MMM, yyyy") ?? "No Date."
        }
    }
    
    private func setupProvider(){
        favoritesProvider.get(id, completion: { game in
            DispatchQueue.main.async {
                self.favoriteSwitch.setOn(true, animated: false)
            }
        })
    }
    
    @IBAction func favoriteSwitchTapped(_ sender: UISwitch) {
        if let game = viewModel.game {
            if sender.isOn {
                favoritesProvider.create(Int32(id), game.name ?? "", game.rating ?? 0, game.backgroundImage ?? "", game.released ?? Date()) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Successfully added", message: "Added to favorites")
                    }
                }
            } else {
                favoritesProvider.delete(id, completion: {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Successfully Removed", message: "Deleted from favorites")
                    }
                })
            }
        }
    }
    
    //MARK: - Error Alert Response
    func showAlert(title: String = "Something Wrong", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
