//
//  MKMapView+Zoom.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import MapKit

extension MKMapView {

    /// Zooms to the provided route for you.
    ///
    /// - Parameters:
    ///   - route: The route to zoom into.
    ///   - animated: Whether or not to animate (defaults to true).
    func zoom(to route: MKRoute, animated: Bool = true) {
        let mapRect = route.polyline.boundingMapRect
        setVisibleMapRect(mapRect, animated: animated)
    }
}
