//
//  PlaceNearbyLocationModel.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation

// MARK: - PlaceNearbyLocationModel
struct PlaceNearbyLocationModel: Decodable {
    let results: [NearbyLocationModel]
}

// MARK: - Result
struct NearbyLocationModel: Decodable {
    let geometry: Geometry
    let name: String
    let reference, scope: String
    let types: [String]
    let vicinity: String
    let photos: [Photo]?
}

// MARK: - Photo
struct Photo: Decodable {
    let photoReference: String
}

// MARK: - Geometry
struct Geometry: Decodable {
    let location: Location
}

// MARK: - Location
struct Location: Decodable {
    let lat, lng: Double
}
