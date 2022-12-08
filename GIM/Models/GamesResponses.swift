//
//  GamesResponses.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//

struct GamesResponses: Codable {
    let count: Int
    let games: [GameResponse]

    enum CodingKeys: String, CodingKey {
        case count
        case games = "results"
    }
}
