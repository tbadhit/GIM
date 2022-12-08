//
//  ViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 20/10/22.
//

import UIKit
import IGListKit

enum CellSection {
    case newReleaseGames(games: [Game])
    case discoverGames(games: [Game])
    case labelSection(text: String)
}

class GameController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchView: UISearchBar!
    private let refreshControl = UIRefreshControl()
    private let alertManager = AlertManager()
    private let networkService = NetworkService()
    private var listSection: [CellSection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        tableView.delegate = self
        tableView.dataSource = self
        checkConnection()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        registerTableCell()
    }
    private func checkConnection() {
        if self.alertManager.noConnection(view: self) {
            self.tableView.isHidden = false
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
            return
        } else {
            getNewReleaseGames()
        }
    }
    private func registerTableCell() {
        tableView.register(
            UINib(
                nibName: "GameTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: GameTableViewCell.id
        )
        tableView.register(
            UINib(
                nibName: "NewReleaseGameTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: NewReleaseGameTableViewCell.id
        )
        tableView.register(
            UINib(
                nibName: "LabelTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: LabelTableViewCell.id
        )
    }
    @objc fileprivate func refreshData() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.listSection.removeAll()
            self.tableView.reloadData()
            self.showLoadingIndicator()
            self.checkConnection()
        }
    }
    fileprivate func getNewReleaseGames() {
        networkService.fetchNewReleaseGames { newReleaseGames in
            self.listSection.append(.labelSection(text: "New Release"))
            self.listSection.append(.newReleaseGames(games: newReleaseGames))
            self.tableView.reloadData()
            self.getDiscoverGames()
        }
    }
    fileprivate func getDiscoverGames() {
        networkService.fetchGames { games in
            self.listSection.append(.labelSection(text: "Discover"))
            self.listSection.append(.discoverGames(games: games))
            self.tableView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    fileprivate func showLoadingIndicator() {
        self.tableView.isHidden = true
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    fileprivate func hideLoadingIndicator() {
        self.tableView.isHidden = false
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }
    @IBAction func searchGame(_ sender: Any) {
        let viewControllerStoryBoardId = "SearchViewScene"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: viewControllerStoryBoardId)
        navigationController?.present(UINavigationController(rootViewController: searchViewController), animated: true)
    }
}

extension GameController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listSection.isEmpty {
            switch listSection[section] {
            case .newReleaseGames(_): return 1
            case .discoverGames(let models): return models.count
            case .labelSection(_): return 1
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !listSection.isEmpty {
            switch listSection[indexPath.section] {
            case .newReleaseGames(let games):
                if let cell = tableView.dequeueReusableCell(
                    withIdentifier: NewReleaseGameTableViewCell.id,
                    for: indexPath) as? NewReleaseGameTableViewCell {
                    cell.configure(with: games)
                    cell.delegate = self
                    return cell
                }
                return UITableViewCell()
            case .discoverGames(let games):
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
            case .labelSection(let text):
                if let cell = tableView.dequeueReusableCell(
                    withIdentifier: LabelTableViewCell.id,
                    for: indexPath) as? LabelTableViewCell {
                    cell.selectionStyle = .none
                    cell.labelSection.text = text
                    return cell
                }
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
}

extension GameController: NewReleaseGameTableViewCellDelegate {
    func didSelectItem(with game: Game) {
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let detailGameViewController = storyboard.instantiateViewController(
            withIdentifier: DetailGameViewController.id) as? DetailGameViewController else {return}
        detailGameViewController.gameId = game.id
        detailGameViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailGameViewController, animated: true)
    }
}

extension GameController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listSection[indexPath.section] {
        case .discoverGames(let games):
            let game = games[indexPath.row]
            let storyboardName = "Main"
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            guard let detailGameViewController = storyboard.instantiateViewController(
                withIdentifier: DetailGameViewController.id) as? DetailGameViewController else {return}
            detailGameViewController.gameId = game.id
            detailGameViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailGameViewController, animated: true)
        case .newReleaseGames(_):
            break
        case .labelSection(_):
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !listSection.isEmpty {
            switch listSection[indexPath.section] {
            case .newReleaseGames(_):
                return 203
            case .discoverGames(_):
                return 90
            case .labelSection(_):
                return 48
            }
        } else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSection.count
    }
}
