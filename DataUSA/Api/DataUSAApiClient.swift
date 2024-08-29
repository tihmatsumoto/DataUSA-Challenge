//
//  DataUSAApiClient.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 29/08/2024.
//

import Foundation

protocol DataUSStaticApiClient {
    static func getPopulationData(populationDataType: String, completion: @escaping (PopulationType?) -> Void,
                                  failure: @escaping (Error?) -> Void)
}

class DataUSApiClient: DataUSStaticApiClient {
    private static let urlPath: String = "https://datausa.io/api/data"
    
    static func getPopulationData(populationDataType: String, completion: @escaping (PopulationType?) -> Void,
                                  failure: @escaping (Error?) -> Void) {
        
        var urlComponents = URLComponents(string: urlPath)
        urlComponents?.queryItems = [
            URLQueryItem(name: "drilldowns", value: populationDataType),
            URLQueryItem(name: "measures", value: "Population")
        ]
        
        guard let url = urlComponents?.url else {
            failure(PopulationError.invalidURL)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { (data, res, err) in
            
            guard let response = res as? HTTPURLResponse else {
                failure(PopulationError.invalidResponse)
                return
            }
            
            if response.statusCode == 400 {
                failure(PopulationError.invalidDataType)
                return
            }
            
            if response.statusCode != 200 {
                failure(PopulationError.invalidResponse)
                return
            }
            
            guard let data = data, err == nil else {
                failure(PopulationError.invalidResponse)
                return
            }
            
            do {
                if let statePopulations = try? JSONDecoder().decode(StateData.self, from: data){
                    completion(.state(statePopulations.data))
                    return
                }
                if let nationPopulations = try? JSONDecoder().decode(NationData.self, from: data){
                    completion(.nation(nationPopulations.data))
                    return
                }
            } catch {
                failure(PopulationError.invalidData)
                return
            }
            
        }.resume()
    }
}
