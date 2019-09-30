//
//  HomeMapViewController.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

var userCoordinate: CLLocationCoordinate2D?

final class HomeMapViewController: UIViewController {
    /// Types filtes for search
    private var searchedTypes = ["restaurant", "bar", "cafe", "bakery", "grocery_or_supermarket"]
    /// Configure UIView container Location..
    private var googleMapView: GMSMapView = {
        let googleMapView = GMSMapView()
        return googleMapView
    }()
    
    /// Configure UIView container establisments and restaurants.
    private var containerCategoryView: UIView = {
        let containerCategoryView = UIView()
        containerCategoryView.backgroundColor = .white
        containerCategoryView.layer.masksToBounds = true
        containerCategoryView.layer.cornerRadius = 15
        containerCategoryView.layer.opacity = 1.0
        return containerCategoryView
    }()
    
    private let placeTitleLabel: UILabel = {
        let placeTitleLabel = UILabel()
        placeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeTitleLabel.font = UIFont(name: "Avenir-Black", size: 17.0)
        placeTitleLabel.textColor = .black
        placeTitleLabel.numberOfLines = 2
        placeTitleLabel.lineBreakMode = NSLineBreakMode.byClipping
        return placeTitleLabel
    }()
    
    private let pinUserLocation: UIImageView = {
        let pinUserLocation = UIImageView()
        pinUserLocation.translatesAutoresizingMaskIntoConstraints = false
        pinUserLocation.image = UIImage.init(named: "locationPin")
        return pinUserLocation
    }()
    private lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 2000
    private var isSearching = false
    private var googlePlacesFilter = [GooglePlace]()
    private var googlePlacesFetched = [GooglePlace]()
    private var isSelectedPin = false
    
    override func viewDidLoad() {
        setupDesignViews()
        setupMapView()
        setupSettingsSearchBar()
    }
    
    // Mark: Interface settings (View)
    /// Functions for the configuration of the HomeViewController Views.
    private func setupDesignViews() {
        addSubViews()
        setupContainerMapView()
        setupContainerCategoryView()
        setupPlaceLabel()
        setupConstraintsSearchBar()
        setupIconPinUserLocation()
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        view.addSubview(googleMapView)
        view.addSubview(containerCategoryView)
        view.addSubview(pinUserLocation)
        containerCategoryView.addSubview(placeTitleLabel)
        containerCategoryView.addSubview(searchBar)
    }
    
    private func setupSettingsSearchBar() {
        searchBar.placeholder = "Search Restaurants"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.contentMode = .center
    }
    
    private func setupContainerMapView() {
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: view.topAnchor),
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupContainerCategoryView(topView: CGFloat = 15,
                                            leadingView: CGFloat = 15,
                                            trailingView: CGFloat = -15,
                                            heightView: CGFloat = 120,
                                            widthView: CGFloat = 220) {
        containerCategoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerCategoryView.topAnchor.constraint(equalTo: view.topAnchor, constant: topView),
            containerCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingView),
            containerCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingView),
            containerCategoryView.heightAnchor.constraint(equalToConstant: heightView),
            containerCategoryView.widthAnchor.constraint(equalToConstant: widthView)])
    }
    
    /// <#Description#>
    private func setupPlaceLabel() {
        placeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeTitleLabel.topAnchor.constraint(equalTo: containerCategoryView.topAnchor, constant: 10),
            placeTitleLabel.leadingAnchor.constraint(equalTo: containerCategoryView.leadingAnchor, constant: 15),
            placeTitleLabel.trailingAnchor.constraint(equalTo: containerCategoryView.trailingAnchor, constant: -50)])
    }
    
    private func setupConstraintsSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: placeTitleLabel.bottomAnchor, constant: 2),
            searchBar.leadingAnchor.constraint(equalTo: containerCategoryView.leadingAnchor, constant: 15),
            searchBar.trailingAnchor.constraint(equalTo: containerCategoryView.trailingAnchor, constant: -5)])
    }
    
    private func setupIconPinUserLocation() {
        pinUserLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinUserLocation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pinUserLocation.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            pinUserLocation.widthAnchor.constraint(equalToConstant: 64),
            pinUserLocation.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    /// Configure MapView
    private func setupMapView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        googleMapView.delegate = self
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) {
            response, error in
            guard let address = response?.firstResult(),
                let lines = address.lines else {
                    return
            }
            self.placeTitleLabel.text = lines.joined(separator: "\n")
            let labelHeight = self.placeTitleLabel.intrinsicContentSize.height
            self.googleMapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top,
                                                      left: 0,
                                                      bottom: labelHeight,
                                                      right: 0)
            if !self.isSelectedPin {
                userCoordinate = coordinate
                self.fetchNearbyPlaces(coordinate: coordinate)
            }
        }
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        googleMapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate,
                                               radius: searchRadius,
                                               types: searchedTypes) {
                                                [weak self]
                                                places in
                                                guard let self = self else { return }
                                                self.googlePlacesFetched = places
                                                self.googlePlacesFilter = places
                                                places.forEach {
                                                    let marker = PlaceMarker(place: $0)
                                                    marker.map = self.googleMapView
                                                }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userCoordinate = location.coordinate
        googleMapView.camera = GMSCameraPosition(target: location.coordinate,
                                                 zoom: 15,
                                                 bearing: 0,
                                                 viewingAngle: 0)
        locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

// MARK: - GMSMapViewDelegate
extension HomeMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            isSelectedPin = false
            googleMapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        let infoView = MarkerInfoView(frame: CGRect(x: 0, y: 0, width: 160, height: 120))
        infoView.nameTextPin = placeMarker.place.name
        if let photo = placeMarker.place.photo {
            infoView.placePhoto.image = photo
        } else {
            infoView.placePhoto.image = UIImage(named: "generic")
        }
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        isSelectedPin = true
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        isSelectedPin = false
        googleMapView.selectedMarker = nil
        return false
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension HomeMapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension HomeMapViewController: UISearchBarDelegate {
    /// It allows to filter the cells by means of the text that the user is looking for.
    ///
    /// - Parameters:
    ///   - searchText: text to search.
    private func filterContentForSearchText(_ searchText: String) {
        googleMapView.clear()
        googlePlacesFilter = googlePlacesFetched.filter({
            (restaurantPin: GooglePlace) -> Bool in
            if restaurantPin.name.lowercased().contains(searchText.lowercased()) ||
                restaurantPin.address.lowercased().contains(searchText.lowercased()) {
                let marker = PlaceMarker(place: restaurantPin)
                marker.map = self.googleMapView
            }
            return restaurantPin.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        if let textTyped = searchBar.text,
            !textTyped.isEmpty {
            filterContentForSearchText(textTyped)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textTyped = searchBar.text,
            !textTyped.isEmpty {
            if isSearching {
                filterContentForSearchText(textTyped)
            }
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        googlePlacesFilter = googlePlacesFetched.map({ (restaurantPin) -> GooglePlace in
            let marker = PlaceMarker(place: restaurantPin)
            marker.map = self.googleMapView
            return restaurantPin
        })
        searchBar.resignFirstResponder()
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let textTyped = searchBar.text, !textTyped.isEmpty {
            filterContentForSearchText(textTyped)
        } else if let textTyped = searchBar.text, textTyped.isEmpty {
            googlePlacesFilter.removeAll()
        }
    }
}
