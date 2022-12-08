//
//  DetailGameViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 23/10/22.
//

import UIKit
import IGListKit
import SkeletonView

enum DetailType {
    case network
    case favorite
}
class DetailGameViewController: UIViewController {
    static let id = "DetailGameViewController"
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textDevelopers: UILabel!
    @IBOutlet weak var textReleased: UILabel!
    @IBOutlet weak var containerRating: UIStackView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var gamePlatforms: UIStackView!
    @IBOutlet weak var gameReleased: UILabel!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameReviewCount: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var developersCollectionView: UICollectionView!
    var gameId: Int?
    var type: DetailType = .network
    var game: Game?
    fileprivate let networkService = NetworkService()
    private let gameProvider = GameProvider.shared
    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(
            updater: ListAdapterUpdater(),
            viewController: self,
            workingRangeSize: 0)
    }()
    private var developers: [Developer] = []
    private var favoriteImage = "heart"
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = developersCollectionView
        adapter.dataSource = self
        switch type {
        case .network:
            showSkeletonEffect()
            getGame()
        case .favorite:
            initGame()
            textDevelopers.isHidden = true
            developersCollectionView.isHidden = true
        }
        checkFavoriteButton()
    }
    private func getGame() {
        networkService.fetchGame(fromId: gameId!) { game in
            self.hideSkeletonEffect()
            self.game = game
            self.initGame()
            self.adapter.performUpdates(animated: true)
            if let developers = self.game?.developers {
                self.developers = developers
            }
        }
    }
    private func initGame() {
        guard let game = game else {return}
        self.gameTitle.text = game.name
        self.gameGenre.text = game.genres
        self.gameReleased.text = game.released
        self.gameDescription.text = game.descriptionRaw
        self.gameRating.text = "\(game.rating ?? 0.0)"
        self.gameReviewCount.text = "\(game.ratingCount ?? 0)"
        self.gamePlatforms.generatePlatformLogo(parentPlatformNames: game.parentPlatformNames)
        switch type {
        case .network:
            if game.state == .new {
                self.gameImage.showAnimatedGradientSkeleton()
                let imageDownloader = ImageDownloader()
                imageDownloader.startDownload(game: game) {
                    DispatchQueue.main.async {
                        self.gameImage.image = game.image
                        self.gameImage.hideSkeleton()
                        self.gameImage.isSkeletonable = false
                    }
                }
            }
        case .favorite:
            self.gameImage.image = game.image
        }
    }
    private func checkFavoriteButton() {
        let isFavorite = gameProvider.isFavorite(gameId: (gameId ?? game?.id) ?? 0)
        if isFavorite {
            favoriteImage = "heart.fill"
            favoriteButton.image = UIImage(systemName: favoriteImage)
        } else {
            favoriteImage = "heart"
            favoriteButton.image = UIImage(systemName: favoriteImage)
        }
    }
    @IBAction func addToFavorite(_ sender: Any) {
        if gameImage.isSkeletonable == true {
            showAlert(
                title: "Can't do it right now",
                message: "Please wait until all of the components are fully loaded.",
                action: "Okay")
            return
        }
        guard let game = game else {return}
        let isFavorite = gameProvider.isFavorite(gameId: gameId ?? game.id)
        if isFavorite {
            gameProvider.deleteFavoriteGame(id: gameId ?? game.id) {
                DispatchQueue.main.async {
                    self.checkFavoriteButton()
                }
            }
        } else {
            gameProvider.createFavoriteGame(game: game) {
                DispatchQueue.main.async {
                    self.checkFavoriteButton()
                }
            }
        }
    }
}

extension DetailGameViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return developers
    }
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return GameDeveloperSectionController()
    }
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DetailGameViewController {
    private func showSkeletonEffect() {
        containerView.isSkeletonable = true
        gameImage.isSkeletonable = true
        containerView.showAnimatedGradientSkeleton()
    }
    private func hideSkeletonEffect() {
        containerView.isSkeletonable = false
        containerView.hideSkeleton()
    }
}
