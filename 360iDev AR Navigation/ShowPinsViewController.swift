//
//  ShowPinsViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import ARCL
import CoreLocation
import UIKit

class ShowPinsViewController: UIViewController {

    let sceneLocationView = SceneLocationView()

    var currentLocation: CLLocation? {
        return sceneLocationView.sceneLocationManager.currentLocation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneLocationView)
        sceneLocationView.frame = view.bounds
        addPins()
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

    /// Adds the pins to the ARCL Scene
    func addPins() {
        guard let currentLocation = currentLocation,
            currentLocation.horizontalAccuracy < 15 else {
                return DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.addPins()
                }
        }

        Action.all.forEach { action in
            guard action.isLocation else {
                return
            }
            guard let location = action.location else {
                return assertionFailure()
            }
            guard let image = action.image else {
                return assertionFailure()
            }

            let node = LocationAnnotationNode(location: location, image: image)

            sceneLocationView.addLocationNodeWithConfirmedLocation(
                locationNode: node)
        }
    }
}
