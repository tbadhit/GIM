//
//  GameResponse.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//

import Foundation

struct GameResponse: Codable {
    let id: Int
    let name: String
    var released: String?
    var imagePath: String?
    var rating: Double?
    var ratingsCount: Int?
    var platforms: [PlatformsResponses]?
    var genres: [GenreResponse]?
    var description: String?
    var developers: [DeveloperResponse]?
    var genresString: String?
    var parentPlatforms: Set<String>?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, released
        case imagePath = "background_image"
        case rating
        case ratingsCount = "ratings_count"
        case platforms = "parent_platforms"
        case genres
        case description = "description_raw"
        case developers
    }
    // swiftlint:disable cyclomatic_complexity
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        for key in CodingKeys.allCases {
            if container.contains(key) {
                switch key {
                case .id:
                    break
                case .name:
                    break
                case .released:
                    let dateString = try container.decode(String?.self, forKey: .released)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let dateString = dateString else {return}
                    let date = dateFormatter.date(from: dateString)
                    dateFormatter.dateFormat = "MMMM d, yyyy"
                    self.released = dateFormatter.string(from: date!)
                case .imagePath:
                    self.imagePath = try container.decode(String?.self, forKey: .imagePath)
                case .rating:
                    let rating = try container.decode(Double?.self, forKey: .rating)
                    guard let rating = rating else {return}
                    self.rating = rating * 2
                case .ratingsCount:
                    self.ratingsCount = try container.decode(Int?.self, forKey: .ratingsCount)
                case .platforms:
                    self.platforms = try container.decode([PlatformsResponses]?.self, forKey: .platforms)
                    var newPlatforms = Set<String>()
                    if let platforms = self.platforms {
                        platforms.forEach { platform in
                            if let platform = platform.platform {
                                if let platformName = platform.slug {
                                    newPlatforms.insert(platformName)
                                }
                            }
                        }
                    }
                    self.parentPlatforms = newPlatforms
                case .genres:
                    self.genres = try container.decode([GenreResponse]?.self, forKey: .genres)
                    var gameGenre = ""
                    for (index, genre) in genres!.enumerated() {
                        if index == (genres!.count - 1) {
                            gameGenre += genre.name
                        } else {
                            gameGenre += "\(genre.name), "
                        }
                    }
                    self.genresString = gameGenre
                case .description:
                    self.description = try container.decode(String?.self, forKey: .description)
                case .developers:
                    self.developers = try container.decode([DeveloperResponse]?.self, forKey: .developers)
                }
            } else {
                switch key {
                case .id:
                    break
                case .name:
                    break
                case .released:
                    self.released = nil
                case .imagePath:
                    self.imagePath = nil
                case .rating:
                    self.rating = nil
                case .ratingsCount:
                    self.ratingsCount = nil
                case .platforms:
                    self.platforms = nil
                case .genres:
                    self.genres = nil
                case .description:
                    self.description = nil
                case .developers:
                    self.developers = nil
                }
            }
        }

    }
}

struct PlatformsResponses: Codable {
    let platform: PlatformResponse?
}

struct PlatformResponse: Codable {
    let slug: String?
}

struct DeveloperResponse: Codable {
    let name: String
    let imagePath: String
    enum CodingKeys: String, CodingKey {
        case name
        case imagePath = "image_background"
    }
}
