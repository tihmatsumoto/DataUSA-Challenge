//
//  PopulationDataView.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 29/08/2024.
//

import UIKit

protocol PopulationDelegate: AnyObject {
    func fetchPopulation(dataType: String)
}

class PopulationDataView: UIView {
    
    private let tableview = UITableView()
    private let populationCellName = "PopulationCell"
    private let populationSegmentControl = UISegmentedControl()
    private let yearPicker = UIPickerView()
    private let itemsFilter = ["Nation", "State"]
    private var inputPopulation: [PopulationModel]? = []
    private var filteredPopulation: [PopulationModel]? = []
    private var availableYears: [String] = []
    
    weak var populationViewDelegate: PopulationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.clear
        
        configureSegmentControl()
        configureYearPicker()
        configureTableView()
    }
    
    private func configureSegmentControl() {
        populationSegmentControl.insertSegment(withTitle: itemsFilter[0], at: 0, animated: true)
        populationSegmentControl.insertSegment(withTitle: itemsFilter[1], at: 1, animated: true)
        populationSegmentControl.addTarget(self, action: #selector(fetchPopulationByDataType), for: .valueChanged)
        
        populationSegmentControl.selectedSegmentIndex = 0
        addSubview(populationSegmentControl)
        populationSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            populationSegmentControl.widthAnchor.constraint(equalToConstant: 200),
            populationSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            populationSegmentControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            populationSegmentControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ])
    }
    
    @objc func fetchPopulationByDataType(sender: UISegmentedControl){
        populationViewDelegate?.fetchPopulation(dataType: itemsFilter[sender.selectedSegmentIndex])
    }
    
    func updatePopulationList(with population: [PopulationModel]) {
        inputPopulation = population
        
        // Extract unique years from the population data
        availableYears = Array(Set(population.map { $0.year })).sorted()
        
        if let firstYear = availableYears.first {
            filterPopulationByYear(year: firstYear)
        }
    }
    
    private func filterPopulationByYear(year: String) {
        filteredPopulation = inputPopulation?.filter { $0.year == year }
        DispatchQueue.main.async {
            // Reload picker view data and select the first year by default
            self.yearPicker.reloadAllComponents()
            self.tableview.reloadData()
        }
    }
    
    private func configureTableView() {
        tableview.register(PopulationTableViewCell.self, forCellReuseIdentifier: populationCellName)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = UIColor.clear
        
        addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableview.topAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: 10),
            tableview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func configureYearPicker() {
        yearPicker.delegate = self
        yearPicker.dataSource = self
        addSubview(yearPicker)
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            yearPicker.widthAnchor.constraint(equalTo: populationSegmentControl.widthAnchor),
            yearPicker.heightAnchor.constraint(equalToConstant: 50),
            yearPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yearPicker.topAnchor.constraint(equalTo: populationSegmentControl.bottomAnchor, constant: 10)
        ])
    }
    
}

extension PopulationDataView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPopulation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let populationList = filteredPopulation else { return PopulationTableViewCell() }
        
        let populationItem = populationList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: populationCellName, for: indexPath) as? PopulationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
        cell.configure(with: populationItem)
        return cell
    }
}

extension PopulationDataView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableYears.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableYears[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedYear = availableYears[row]
        filterPopulationByYear(year: selectedYear)
    }
}

