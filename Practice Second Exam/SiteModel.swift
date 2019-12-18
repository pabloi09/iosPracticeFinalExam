//
//  Model.swift
//  Hola Mundo con SwiftUI
//
//  Created by Santiago Pavón Gómez on 09/12/2019.
//  Copyright © 2019 IWEB. All rights reserved.
//

import MapKit

enum Site: String {
    case coupertino = "Coupertino"
    case hBeach = "Huntington Beach"
    case googleZ = "Google Zurich"
    
    func coordinate() -> CLLocationCoordinate2D {
        switch self {
        case .coupertino:
            return CLLocationCoordinate2D(
                latitude: 37.330672,
                longitude: -122.007479)
        case .hBeach:
            return  CLLocationCoordinate2D(
                latitude:33.653302,
                longitude: -118.006026)
        case .googleZ:
            return CLLocationCoordinate2D(
                latitude: 47.365545,
                longitude: 8.524680)
        }
    }
}
