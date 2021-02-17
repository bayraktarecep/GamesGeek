//
//  MainViewController.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 14.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = MainViewModel()
    let carouselViewModel = MainCarouselViewModel()
    var id = -1
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carouselCollectionView.dataSource = self
        
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        pageControl.numberOfPages = 20

        
        tableView.rowHeight = 110
        
        loadCarouselData()
        loadData()
        
    }
    
    //MARK: - Load Data from the URL for TableView and Carousel
    private func loadData() {
        
        viewModel.onErrorResponse = { error in
            self.showAlert(message: error)
        }
        
        viewModel.onSuccessResponse = {
            self.tableView.reloadData()
        }
        
        viewModel.fetchData()
        
    }
    
    private func loadCarouselData() {
        
        carouselViewModel.onErrorResponse = { error in
            self.showAlert(message: error)
        }
        
        carouselViewModel.onSuccessResponse = {
            self.carouselCollectionView.reloadData()
        }
        
        carouselViewModel.fetchData()
        
    }
    
    
    //MARK: - Search Bar
    @IBAction func searchGame(_ sender: Any) {
        viewModel.fetchData(search: textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
    }
    
    //MARK: - Error Alert Response
    func showAlert(title: String = "Something Wrong", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: - CollectionView and TableView extensions

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselViewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCarouselCollectionViewCell
        let cellData = carouselViewModel.games[indexPath.row]
        cell.loadImages(data: cellData)
        
        return cell
        
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController
        vc?.id = carouselViewModel.games[indexPath.row].id!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.loadWith(data: viewModel.games[indexPath.row])
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController
        vc?.id = viewModel.games[indexPath.row].id!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

