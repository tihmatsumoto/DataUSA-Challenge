//
//  NationData.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 27/08/2024.
//

import Foundation

struct NationData: Codable{
    let data: [NationPopulationData]
}

struct NationPopulationData: Codable {
    let idNation: String
    let nation: String
    let idYear: Int
    let year: String
    let population: Int
    let slugNation: String

    enum CodingKeys: String, CodingKey {
        case idNation = "ID Nation"
        case nation = "Nation"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugNation = "Slug Nation"
    }
}
