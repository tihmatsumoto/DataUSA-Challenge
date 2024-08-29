//
//  PopulationDataTableViewCell.swift
//  DataUSA
//
//  Created by Tiemi Matsumoto on 27/08/2024.
//

import UIKit

class PopulationTableViewCell: UITableViewCell {
    
    private let idLabel = UILabel()
    private let locationLabel = UILabel()
    private let yearLabel = UILabel()
    private let populationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(idLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(populationLabel)
        
        idLabel.font = UIFont.systemFont(ofSize: 14)
        idLabel.textColor = .gray
        
        locationLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        locationLabel.textColor = .black
        
        yearLabel.font = UIFont.systemFont(ofSize: 14)
        yearLabel.textColor = .gray
        
        populationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        populationLabel.textColor = .black
        populationLabel.textAlignment = .right
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        populationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            locationLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 4),
            
            yearLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            yearLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            populationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            populationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
    }
    
    func configure(with model: PopulationModel) {
        idLabel.text = "ID: \(model.id)"
        locationLabel.text = model.location
        yearLabel.text = "Year: \(model.year)"
        populationLabel.text = "\(model.population)"
    }
}

