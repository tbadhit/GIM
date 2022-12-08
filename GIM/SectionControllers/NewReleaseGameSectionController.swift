//
//  EmbeddedGameSectionController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 26/10/22.
//

import UIKit
import IGListKit

class NewReleaseGameSectionController: ListSectionController {
    private var game: Game?
    public weak var delegate: NewReleaseGameTableViewCellDelegate?
    init(delegate: NewReleaseGameTableViewCellDelegate?) {
        self.delegate = delegate
    }
}

extension NewReleaseGameSectionController {
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        let width = context.containerSize.width / 1.5
        return CGSize(width: width, height: 203)
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(
            withNibName: NewReleaseGameCollectionViewCell.name,
            bundle: nil,
            for: self,
            at: index)
        if let cell = cell as? NewReleaseGameCollectionViewCell {
            cell.gameName.text = game?.name
            cell.gameImage.image = game?.image
            cell.gameImage.layer.cornerRadius = 5
            cell.gameGenre.text = game?.genres
            if game?.state == .new {
                cell.gameImage.showAnimatedGradientSkeleton()
                let imageDownloader = ImageDownloader()
                if let game = game {
                    imageDownloader.startDownload(game: game) {
                        DispatchQueue.main.async {
                            guard let context = self.collectionContext else {return }
                            context.performBatch(animated: false) { batchContext in
                                batchContext.reload(self)
                            }
                        }
                    }
                }
            } else {
                cell.gameImage.hideSkeleton()
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    override func didUpdate(to object: Any) {
        game = object as? Game
        inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    override func didSelectItem(at index: Int) {
        guard let game = game else {return}
        delegate?.didSelectItem(with: game)
    }
}
