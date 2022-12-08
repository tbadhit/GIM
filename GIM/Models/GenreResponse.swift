//
//  GenreResponse.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//

struct GenreResponse: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
