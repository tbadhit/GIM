//
//  ShortImageCollectionViewCell.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 23/10/22.
//

import UIKit

class DeveloperCollectionViewCell: UICollectionViewCell {
    static let id = "DeveloperCollectionViewCell"
    @IBOutlet weak var developerName: UILabel!
    @IBOutlet weak var developerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
