//
//  GameTableViewCell.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 27/10/22.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    static let id = "GameTableViewCell"

    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 3,
                right: 0)
        )
    }
    public func configure(with game: Game, indexPath: IndexPath) {
        selectionStyle = .none
        gameName.text = game.name
        gameDate.text = game.released
        gameImage.layer.cornerRadius = 5
        gameGenre.text = game.genres
        guard let rating = game.rating else {return}
        gameRating.text = String(format: "%.1f", rating)
    }
}
