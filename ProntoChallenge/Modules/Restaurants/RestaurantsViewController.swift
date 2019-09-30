//
//  RestaurantsViewController.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class RestaurantsViewController: UIViewController {
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    private let locationManager = CLLocationManager()
    private let searchRadius: Double = 2000
    /// Save the data to show in every row of the tableView.
    private lazy var cells: [NearbyLocationModel] = [NearbyLocationModel]()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    /// Configure UIView container establisments and restaurants.
    private var containerTableView: UIView = {
        let containerTableView = UIView()
        containerTableView.backgroundColor = .white
        containerTableView.layer.masksToBounds = true
        containerTableView.layer.cornerRadius = 15
        return containerTableView
    }()
    private var filteredCells = [NearbyLocationModel]()
    private let dataProvider = GoogleDataProvider()
    private var rowHeight: CGFloat = 205
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerTableViewCells()
        addSubViews()
        setupContainerTableView()
        setupConstraintsTableView()
        if let userCoordinate = userCoordinate {
            fetchNearbyPlaces(coordinate: userCoordinate)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
    }
    
    private func registerTableViewCells() {
        tableView.register(NearbyViewCell.self,
                           forCellReuseIdentifier: NearbyViewCell.reuseIdentifier)
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        containerTableView.backgroundColor = .white
        view.addSubview(containerTableView)
        containerTableView.addSubview(tableView)
    }
    
    private func setupContainerTableView() {
        containerTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerTableView.topAnchor.constraint(equalTo: view.topAnchor),
            containerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerTableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerTableView.bottomAnchor)])
    }

    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        dataProvider.fetchPlacesNearCoordinate(coordinate,
                                               radius: searchRadius,
                                               types: searchedTypes) {
                                                [weak self]
                                                places in
                                                guard let self = self else { return }
                                                if places.isEmpty {
                                                    self.showAlertLimitApi()
                                                }
                                                self.cells = places.map({ (place) -> NearbyLocationModel in
                                                    let geo = Geometry(location: Location(lat: place.coordinate.latitude,
                                                                                          lng: place.coordinate.longitude))
                                                    let placeModel = NearbyLocationModel(geometry: geo,
                                                                                         name: place.name,
                                                                                         reference: place.photoReference ?? "",
                                                                                         scope: "",
                                                                                         types: [""],
                                                                                         vicinity: place.placeType,
                                                                                         photos: nil)
                                                    return placeModel
                                                })
                                                if !self.cells.isEmpty {
                                                    self.tableView.reloadData()
                                                }
        }
    }
    
    private func showAlertLimitApi() {
        let alert = UIAlertController(title: "Alert",
                                      message: "If you have exceeded your daily request quota for Google API, try later please.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cells[indexPath.row]
        let categoryCell: NearbyViewCell = tableView.dequeue(for: indexPath)
        categoryCell.fillData(using: model)
        return categoryCell
    }
}
