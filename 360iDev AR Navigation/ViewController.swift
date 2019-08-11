//
//  ViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
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

    var location: CLLocation? {
        switch self {
        case .navigateToConference:
            return CLLocation(latitude: 39.7456001, longitude: -105.023832)
        case .navigateToHenrys:
            return CLLocation(latitude: 39.7440861, longitude: -104.9915639)
        case .navigateToFoodTrucks:
            return CLLocation(latitude: 39.7337442, longitude: -104.9972431)
        case .navigateToRhinoBeerGarden:
            return CLLocation(latitude: 39.7701405, longitude: -104.9735078)
        default:
            return nil
        }
    }

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
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let url = URL(string: "https://360idev.com/") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            guard indexPath.row < Action.all.count else {
                return
            }
            // TODO: Handle actions
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return Action.all.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: "LogoCell", for: indexPath)
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ActionCell", for: indexPath)
        guard indexPath.row < Action.all.count else {
            return cell
        }
        cell.textLabel?.text = Action.all[indexPath.row].rawValue
        return cell
    }

}
