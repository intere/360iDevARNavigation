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

                self.map(routes: response.routes)
                self.show(routes: response.routes)
            }
        }
    }

    func map(routes: [MKRoute]) {
        mapView.addOverlays(routes.map({ $0.polyline }))
        mapView.zoom(to: routes)
    }

    func show(routes: [MKRoute]) {
        guard let location = currentLocation,
            location.horizontalAccuracy < 15 else {
                return DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.show(routes: routes)
                }
        }

        sceneLocationView.addRoutes(routes: routes)
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

// MARK: - Helpers

extension MKMapView {

    func zoom(to routes: [MKRoute], animated: Bool = true) {
        guard let route = routes.first else {
            return
        }

        let mapRect = route.polyline.boundingMapRect

        setVisibleMapRect(mapRect, animated: animated)
    }

    func zoomRegion(for routes: [MKRoute]) -> MKCoordinateRegion {
        let points = routes.map({ CLLocation(coordinate: $0.polyline.coordinate, altitude: 0) })
        return zoomRegion(for: points)
    }

    /// Provides a zoom region for the provided points
    ///
    /// - Parameter points: The points to calculate the zoom region for.
    /// - Returns: The zoom region that allows you to see all of the points.
    func zoomRegion(for points: [CLLocation]) -> MKCoordinateRegion {
        return getZoomRegion(points)
    }

    /// helper that will figure out what region on the map should be visible, based on your current points.
    ///
    /// - Parameter points: the points to analyze to determine the zoom window.
    /// - Returns: A zoom region.
    func getZoomRegion(_ points: [CLLocation]) -> MKCoordinateRegion {
        let latitudes = points.map { $0.coordinate.latitude }
        let longitudes = points.map { $0.coordinate.longitude }

        guard let maxLat = latitudes.max(), let minLat = latitudes.min(),
            let maxLong = longitudes.max(), let minLong = longitudes.min() else {
                return MKCoordinateRegion()
        }

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
}
