//
//  ShortGameImageSectionController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 23/10/22.
//

import UIKit
import IGListKit

class GameDeveloperSectionController: ListSectionController {

    var developer: Developer?
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}

extension GameDeveloperSectionController {
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        let width = context.containerSize.width
        return CGSize(width: width, height: 120)
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(
            withIdentifier: DeveloperCollectionViewCell.id,
            for: self, at: index)
        if let cell = cell as? DeveloperCollectionViewCell {
            cell.developerImage.layer.cornerRadius = 10
            cell.developerImage.image = developer?.image
            cell.developerName.text = developer?.name
            if developer?.state == .new {
                cell.developerImage.showAnimatedGradientSkeleton()
                startDownload()
            } else {
                cell.developerImage.hideSkeleton()
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    override func didUpdate(to object: Any) {
        developer = object as? Developer
    }
    override func didSelectItem(at index: Int) {
        let viewControllerStoryBoardId = "GameDeveloperViewController"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let gameDeveloperViewController = storyboard.instantiateViewController(
            withIdentifier: viewControllerStoryBoardId) as? GameDeveloperViewController else {return}
        gameDeveloperViewController.developer = developer
        if developer?.state == .downloaded {
            viewController?.navigationController?.present(
                UINavigationController(
                    rootViewController: gameDeveloperViewController),
                    animated: true)
        }
    }
}

extension GameDeveloperSectionController {
    fileprivate func startDownload() {
        let imageDownloader = ImageDownloader()
        if developer?.state == .new {
            Task {
                do {
                    guard let imageURL = developer?.imagePath else {return}
                    guard let url = URL(string: imageURL) else {return}
                    let image = try await imageDownloader.downloadImage(url: url)
                    developer?.state = .downloaded
                    developer?.image = image
                    DispatchQueue.main.async {
                        guard let context = self.collectionContext else {
                            return
                        }
                        context.performBatch(animated: false) { batchContext in
                            batchContext.reload(self)
                        }
                    }
                } catch {
                    developer?.state = .failed
                    developer?.image = nil
                }
            }
        }
    }
}
