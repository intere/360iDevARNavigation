//
//  NavigateToViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import ARCL
import Cartography
import MapKit
import UIKit

class NavigateToViewController: UIViewController {
    let sceneLocationView = SceneLocationView()
    let mapView = MKMapView()
    let activityView = UIActivityIndicatorView(style: .whiteLarge)

    var currentLocation: CLLocation? {
        return sceneLocationView.sceneLocationManager.currentLocation
    }

    var action: Action? {
        didSet {
            navigate(to: action?.address)
            title = action?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        [sceneLocationView, mapView, activityView].forEach { view.addSubview($0) }

        constrain(view, sceneLocationView, mapView, activityView) { view, sceneLocationView, mapView, activityView in
            sceneLocationView.left == view.left
            sceneLocationView.top == view.top
            sceneLocationView.right == view.right
            sceneLocationView.bottom == view.bottom


            activityView.centerX == view.centerX
            activityView.centerY == view.centerY

            mapView.left == view.left
            mapView.top == activityView.bottom + 60
            mapView.right == view.right
            mapView.bottom == view.bottom
        }

        showActivityControl()

        mapView.showsUserLocation = true
        mapView.delegate = self
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

    func showActivityControl() {
        activityView.isHidden = false
        activityView.startAnimating()
    }

    func hideActivityControl() {
        activityView.isHidden = false
        activityView.stopAnimating()
    }

    /// Searches for the provided address and if a MKMapItem comes back
    /// it then gets directions to that location.
    ///
    /// - Parameter address: The address you want to navigate to.
    func navigate(to address: String?) {
        guard let address = address else {
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if let error = error {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "Error searching for \(address): \(error.localizedDescription)")
                }
            }
            guard let response = response else {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "No response back searching for \(address), please try again.")
                }
            }
            guard let destination = response.mapItems.first else {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "No routes returned for \(address), please try again.")
                }
            }

            self?.navigate(to: destination)
        }
    }

    /// Finds directions to the provided MKMapItem (location) and then shows
    /// those directions on the map and in ARCL.
    ///
    /// - Parameter mapLocation: The mapLocation to navigate to.
    func navigate(to mapLocation: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapLocation
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            if let error = error {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "Error get directions: \(error.localizedDescription)")
                }
            }
            guard let response = response else {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "No directions response received, please try again.")
                }
            }
            guard let route = response.routes.first else {
                return DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "No navigation route received, please try again.")
                }
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.map(route: route)
                self.show(route: route)
            }
        }
    }

    /// Shows the route on the map.
    ///
    /// - Parameter route: The route to show on the map.
    func map(route: MKRoute) {
        mapView.addOverlay(route.polyline)
        mapView.zoom(to: route)
    }

    /// Shows the route in AR.
    ///
    /// - Parameter route: The route to be shown.
    func show(route: MKRoute) {
        guard let location = currentLocation,
            location.horizontalAccuracy < 15 else {
                return DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.show(route: route)
                }
        }

        sceneLocationView.addRoutes(routes: [route])
        hideActivityControl()
    }

}

// MKMapViewDelegate

extension NavigateToViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = .blue
        pr.lineWidth = 5
        return pr
    }

}
