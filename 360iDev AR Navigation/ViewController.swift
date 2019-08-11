//
//  ViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import UIKit

/// These are the actions for each (non-title) cell:
enum Action: String {
    case showPins = "Show Location Pins"
    case navigateToConference = "Navigate to Hyatt"
    case navigateToHenrys = "Navigate to Henry's"
    case navigateToFoodTrucks = "Navigate to Food Trucks"

    static let all: [Action] = [
        .showPins,
        .navigateToConference,
        .navigateToHenrys,
        .navigateToFoodTrucks
    ]
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
