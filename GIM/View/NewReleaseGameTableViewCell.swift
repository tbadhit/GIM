//
//  NewReleaseGameTableViewCell.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 27/10/22.
//

import UIKit
import IGListKit

protocol NewReleaseGameTableViewCellDelegate: AnyObject {
    func didSelectItem(with game: Game)
}

class NewReleaseGameTableViewCell: UITableViewCell {
    static let id = "NewReleaseGameTableViewCell"
    @IBOutlet weak var collectionVIew: UICollectionView!
    public weak var delegate: NewReleaseGameTableViewCellDelegate?
    private var listNewReleaseGame: [Game] = []
    private lazy var adapter: ListAdapter = {
        return ListAdapter(
            updater: ListAdapterUpdater(),
            viewController: self.parentViewController,
            workingRangeSize: 1)
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adapter.collectionView = collectionVIew
        self.adapter.dataSource = self
    }
    public func configure(with newReleaseGames: [Game]) {
        self.listNewReleaseGame = newReleaseGames
        adapter.performUpdates(animated: true)
    }
}

extension NewReleaseGameTableViewCell: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return listNewReleaseGame
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return NewReleaseGameSectionController(delegate: delegate)
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    fileprivate func startDownload(game: Game) {
        let imageDownloader = ImageDownloader()
        if game.state == .new {
            Task {
                do {
                    guard let imageURL = game.imagePath else {return}
                    guard let url = URL(string: imageURL) else {return}
                    let image = try await imageDownloader.downloadImage(url: url)
                    game.state = .downloaded
                    game.image = image
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}
