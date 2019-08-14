//
//  Action.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import CoreLocation
import UIKit

/// These are the actions for each (non-title) cell:
enum Action: String {
    case showPins = "Show Location Pins"
    case navigateToConference = "Navigate to Hyatt"
    case navigateToHenrys = "Navigate to Henry's Tavern"
    case navigateToFoodTrucks = "Navigate to Food Trucks"
    case navigateToRhinoBeerGarden = "Navigate to RiNo Beer Garden"

    static let all: [Action] = [
        .showPins,
        .navigateToConference,
        .navigateToHenrys,
        .navigateToFoodTrucks,
        .navigateToRhinoBeerGarden
    ]

    /// Is this Action a location?
    var isLocation: Bool {
        switch self {
        case .showPins:
            return false
        default:
            return true
        }
    }

    /// Get the title for this action's view controller
    var title: String {
        switch self {
        case .showPins:
            return "Pins"
        case .navigateToConference:
            return "Hyatt"
        case .navigateToHenrys:
            return "Henry's"
        case .navigateToFoodTrucks:
            return "Food Trucks"
        case .navigateToRhinoBeerGarden:
            return "Beer Garden"
        }
    }

    /// Get the location of this action with the provided elevation.
    ///
    /// - Parameter elevation: The elevation to set on the pin.
    /// - Returns: A CLLocation with the appropriate location and altitude.
    func location(with elevation: CLLocationDistance) -> CLLocation? {
        switch self {
        case .navigateToConference:
            return CLLocation(latitude: 39.7456001, longitude: -105.023832, altitude: elevation)
        case .navigateToHenrys:
            return CLLocation(latitude: 39.7440861, longitude: -104.9915639, altitude: elevation)
        case .navigateToFoodTrucks:
            return CLLocation(latitude: 39.7337442, longitude: -104.9972431, altitude: elevation)
        case .navigateToRhinoBeerGarden:
            return CLLocation(latitude: 39.7701405, longitude: -104.9735078, altitude: elevation)
        default:
            return nil
        }
    }

    /// Get the address for this pin (for navigation).
    var address: String? {
        switch self {
        case .navigateToConference:
            return "1750 Welton St, Denver, CO 80202"
        case .navigateToHenrys:
            return "500 16th St, Denver, CO 80202"
        case .navigateToFoodTrucks:
            return "Civic Center, Denver, CO"
        case .navigateToRhinoBeerGarden:
            return "3800 Walnut St, Denver, CO 80205"
        default:
            return nil
        }
    }

    /// Get the image for this pin.
    var image: UIImage? {
        switch self {
        case .navigateToConference:
            return UIImage(named: "hyatt_bubble")
        case .navigateToHenrys:
            return UIImage(named: "henrys_bubble")
        case .navigateToFoodTrucks:
            return UIImage(named: "civic_center_bubble")
        case .navigateToRhinoBeerGarden:
            return UIImage(named: "beer_garden_bubble")
        default:
            return nil
        }
    }
}
