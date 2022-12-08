//
//  Game.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//

import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class Game: NSObject {
    let id: Int
    let name: String
    let released: String?
    var imagePath: String?
    let rating: Double?
    let genres: String?
    let descriptionRaw: String?
    let ratingCount: Int?
    let parentPlatformNames: Set<String>?
    var developers: [Developer]?
    var state: DownloadState = .new
    var image: UIImage? = UIImage(named: "noImage")
    init(id: Int,
         name: String,
         released: String?,
         imagePath: String?,
         rating: Double?,
         genres: String?,
         descriptionRaw: String?,
         ratingCount: Int?,
         parentPlatformNames: Set<String>?,
         developers: [Developer]?) {
        self.id = id
        self.name = name
        self.released = released
        self.imagePath = imagePath
        self.rating = rating
        self.genres = genres
        self.descriptionRaw = descriptionRaw
        self.ratingCount = ratingCount
        self.parentPlatformNames = parentPlatformNames
        self.developers = developers
    }
    init(id: Int32,
         name: String,
         released: String?,
         image: Data?,
         rating: Double?,
         genres: String?,
         descriptionRaw: String?,
         ratingCount: Int64?,
         parentPlatformNames: Set<String>?,
         developers: [Developer]?) {
        self.id = Int(id)
        self.name = name
        self.released = released
        self.image = UIImage(data: image ?? #imageLiteral(resourceName: "noImage").jpegData(compressionQuality: 1)!)
        self.rating = rating
        self.genres = genres
        self.descriptionRaw = descriptionRaw
        self.ratingCount = Int(ratingCount ?? 0)
        self.parentPlatformNames = parentPlatformNames
        self.developers = developers
    }
}

class Developer: NSObject {
    let name: String
    var imagePath: String?
    var state: DownloadState = .new
    var image: UIImage? = UIImage(named: "noImage")
    init(name: String, imagePath: String) {
        self.name = name
        self.imagePath = imagePath
    }
    init(name: String, image: Data?) {
        self.name = name
        self.image = UIImage(data: image ?? #imageLiteral(resourceName: "noImage").jpegData(compressionQuality: 1)!)
    }
}
