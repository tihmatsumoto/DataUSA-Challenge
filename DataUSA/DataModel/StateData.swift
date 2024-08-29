//
//  StateData.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 28/08/2024.
//
import Foundation

struct StateData: Codable{
    let data: [StatePopulationData]
}

struct StatePopulationData: Codable {
    let idState: String
    let state: String
    let idYear: Int
    let year: String
    let population: Int
    let slugState: String

    enum CodingKeys: String, CodingKey {
        case idState = "ID State"
        case state = "State"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugState = "Slug State"
    }
}



