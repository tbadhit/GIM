//
//  GameDeveloperViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 26/10/22.
//

import UIKit

class GameDeveloperViewController: UIViewController {

    @IBOutlet weak var developerName: UILabel!
    @IBOutlet weak var developerImage: UIImageView!
    var developer: Developer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.developerImage.image = developer?.image
        self.developerName.text = developer?.name
    }

}
