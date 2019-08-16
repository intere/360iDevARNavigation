//
//  UIViewController+Alert.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import UIKit

extension UIViewController {

    typealias AlertOKCallback = (UIAlertAction) -> Void

    /// Shows an alert with a title of "Error" and an "OK" button that dismisses
    /// the alert.
    ///
    /// - Parameter message: The message to show in the alert.
    func showErrorAlert(message: String, completion handler: AlertOKCallback? = nil) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))

        present(alertVC, animated: true)
    }

}
