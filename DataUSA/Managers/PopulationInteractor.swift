//
//  PopulationInteractor.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 27/08/2024.
//

import Foundation

protocol PopulationService : AnyObject {
    func getPopulationSuccess(population: [PopulationModel])
    func getPopulationFailWithError(error: String)
}

class PopulationInteractor {
    
    weak var delegate: PopulationService?
    var dataUSApiClient: DataUSStaticApiClient.Type = DataUSApiClient.self
    
    func getPopulation(dataType: String){
        
        if dataType.isEmpty{
            delegate?.getPopulationFailWithError(error: "Invalid Data Type")
            return
        }
                
        dataUSApiClient.getPopulationData(populationDataType: dataType){ [weak self] response in
                   guard let populationData = response else {
                       self?.delegate?.getPopulationFailWithError(error: "Unexpected Error")
                       return
                   }
                   
            let populationList: [PopulationModel] = self?.mapToPopulationModel(responseData: populationData) ?? []
            self?.delegate?.getPopulationSuccess(population: populationList)
            return
            
        } failure: { [weak self] apiError in
            
            guard let error = apiError else{
                self?.delegate?.getPopulationFailWithError(error: "Unexpected Error")
                return
            }
            
            switch error {
            case PopulationError.invalidURL:
                self?.delegate?.getPopulationFailWithError(error: "Invalid URL")
                return
            case PopulationError.invalidResponse:
                self?.delegate?.getPopulationFailWithError(error: "Invalid Response")
                return
            case PopulationError.invalidData:
                self?.delegate?.getPopulationFailWithError(error: "Data is invalid")
                return
            case PopulationError.invalidDataType:
                self?.delegate?.getPopulationFailWithError(error: "Invalid Population Type")
                return
            default:
                self?.delegate?.getPopulationFailWithError(error: "Unexpected Error")
                return
            }
        }
    }
    
    func mapToPopulationModel(responseData: PopulationType) -> [PopulationModel] {
        switch responseData {
        case .state(let statePopulations):
            return statePopulations.map { statePopulation in
                PopulationModel(
                    id: statePopulation.idState,
                    location: statePopulation.state,
                    idYear: statePopulation.idYear,
                    year: statePopulation.year,
                    population: statePopulation.population,
                    slugLocation: statePopulation.slugState
                )
            }
        case .nation(let nationPopulations):
            return nationPopulations.map { nationPopulation in
                PopulationModel(
                    id: nationPopulation.idNation,
                    location: nationPopulation.nation,
                    idYear: nationPopulation.idYear,
                    year: nationPopulation.year,
                    population: nationPopulation.population,
                    slugLocation: nationPopulation.slugNation
                )
            }
        }
    }
}
