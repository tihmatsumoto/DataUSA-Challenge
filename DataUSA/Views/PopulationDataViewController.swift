//
//  NationViewController.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 27/08/2024.
//
import UIKit

class PopulationDataViewController: UIViewController {
    
    private let populationDataView = PopulationDataView()
    private let populationInteractor = PopulationInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        populationDataView.populationViewDelegate = self
        populationInteractor.delegate = self
        
        configureUI()
        //Load Default
        populationInteractor.getPopulation(dataType: "Nation")
    }
    
    private func configureUI() {
        title = "Population Tracker"
        
        view.addSubview(populationDataView)
        
        populationDataView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            populationDataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            populationDataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            populationDataView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            populationDataView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension PopulationDataViewController: PopulationDelegate {
    func fetchPopulation(dataType: String) {
        populationInteractor.getPopulation(dataType: dataType)
    }
}

extension PopulationDataViewController: PopulationService{
    func getPopulationSuccess(population: [PopulationModel]) {
        populationDataView.updatePopulationList(with: population)
    }
    
    func getPopulationFailWithError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
