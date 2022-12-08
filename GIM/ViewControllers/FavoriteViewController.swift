//
//  FavoriteViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 02/11/22.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private var games: [Game] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: "GameTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: GameTableViewCell.id
        )
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    private func loadData() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        GameProvider.shared.getAllFavoriteGames { games in
            DispatchQueue.main.async {
                self.games.removeAll()
                self.games = games
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if games.count == 0 {
            self.tableView.setEmptyMessage("Favorite is empty", color: .gray)
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
            return cell
        }
        return UITableViewCell()
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let detailGameViewController = storyboard.instantiateViewController(
            withIdentifier: DetailGameViewController.id) as? DetailGameViewController else {return}
        detailGameViewController.game = game
        detailGameViewController.type = .favorite
        detailGameViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailGameViewController, animated: true)
    }
}
