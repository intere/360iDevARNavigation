//
//  ViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import CoreLocation
import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
            if indexPath.row == 0 {
                let vc = ShowPinsViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = NavigateToViewController()
                vc.action = Action.all[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
        guard indexPath.row < Action.all.count else {
            return cell
        }

        cell.textLabel?.text = Action.all[indexPath.row].rawValue
        return cell
    }

}

extension CLLocation {

    convenience init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance) {
        self.init(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: altitude)
    }

}
