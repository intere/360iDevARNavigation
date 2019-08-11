//
//  NavigateToViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import ARCL
import MapKit
import UIKit

class NavigateToViewController: UIViewController {
    let sceneLocationView = SceneLocationView()

    var currentLocation: CLLocation? {
        return sceneLocationView.sceneLocationManager.currentLocation
    }

    var action: Action? {
        didSet {
            navigate(to: action?.address)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneLocationView)
        sceneLocationView.frame = view.bounds
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }
}

// MARK: - Implementation

extension NavigateToViewController {

    func navigate(to address: String?) {
        guard let address = address else {
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if let error = error {
                return assertionFailure("Error searching for \(address): \(error.localizedDescription)")
            }
            guard let response = response, let destination = response.mapItems.first else {
                return assertionFailure("No response or empty response")
            }

            self?.navigate(to: destination)
        }
    }

    func navigate(to mapLocation: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapLocation
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            if let error = error {
                return print("Error getting directions: \(error.localizedDescription)")
            }
            guard let response = response else {
                return assertionFailure("No error, but no response, either.")
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.show(routes: response.routes)
            }
        }
    }

    func show(routes: [MKRoute]) {
        guard let location = currentLocation,
            location.horizontalAccuracy < 15 else {
                return DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.show(routes: routes)
                }
        }

        self.sceneLocationView.addRoutes(routes: routes)
    }

}
