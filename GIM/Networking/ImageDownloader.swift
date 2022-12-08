//
//  ImageDownloader.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 23/10/22.
//

import UIKit

class ImageDownloader {
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
    func startDownload(game: Game, completionHandler: @escaping () -> Void) {
        if game.state == .new {
            Task {
                do {
                    guard let imageURL = game.imagePath else {return}
                    guard let url = URL(string: imageURL) else {return}
                    let image = try await downloadImage(url: url)
                    game.state = .downloaded
                    game.image = image
                    completionHandler()
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}
