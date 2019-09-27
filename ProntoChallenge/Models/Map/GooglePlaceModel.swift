//
//  GooglePlaceModel.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

final class GooglePlace {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var placeType: String
    var photoReference: String?
    var photo: UIImage?
    
    init(locationModel: NearbyLocationModel, acceptedTypes: [String]) {
        let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
        var foundType = "restaurant"
        for type in locationModel.types {
            if possibleTypes.contains(type) {
                foundType = type
                break
            }
        }
        name = locationModel.name
        address = locationModel.vicinity
        let lat = locationModel.geometry.location.lat as CLLocationDegrees
        let lng = locationModel.geometry.location.lng as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        photoReference = locationModel.photos?[0].photoReference
        placeType = foundType
    }
}
