//
//  SearchGameViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 25/10/22.
//

import UIKit
import IGListKit

class SearchGameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let networkService = NetworkService()
    private var searchText: String = ""
    private var games: [Game] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadingIndicator.isHidden = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        tableView.register(
            UINib(
                nibName: "GameTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: GameTableViewCell.id)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    fileprivate func searchGame() {
        networkService.searchGames(key: searchText) { games in
            self.games = games
            self.hideLoadingIndicator()
            self.tableView.reloadData()
        }
    }
    fileprivate func showLoadingIndicator() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.tableView.isHidden = true
    }
    fileprivate func hideLoadingIndicator() {
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.tableView.isHidden = false
    }
}

extension SearchGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if games.count == 0 {
            if searchText != "" {
                self.tableView.setEmptyMessage("\"\(searchText)\" Not Found", color: UIColor(named: "defaultColor")!)
            }
        } else {
            self.tableView.restore()
        }
        return games.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.id,
            for: indexPath) as? GameTableViewCell {
            cell.configure(with: game, indexPath: indexPath)
            cell.gameImage.image = game.image
            if game.state == .new {
                cell.gameImage.showAnimatedGradientSkeleton()
                let imageDownloader = ImageDownloader()
                imageDownloader.startDownload(game: game) {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                cell.gameImage.hideSkeleton()
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let detailGameViewController = storyboard.instantiateViewController(
            withIdentifier: DetailGameViewController.id) as? DetailGameViewController else {return}
        detailGameViewController.gameId = game.id
        detailGameViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailGameViewController, animated: true)
    }
}

extension SearchGameViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {
        self.searchText = searchText
        self.showLoadingIndicator()
        searchGame()
    }
}
