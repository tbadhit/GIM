//
//  AlertManager.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 26/10/22.
//

import UIKit

class AlertManager {
    private func networkError(errorName: String) -> (alert: UIAlertController, animated: Bool) {
        let alert = UIAlertController(
            title: "\(errorName)!",
            message: "Check your internet connection and pull down the page to refresh.",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        return (alert, true)
    }

    func noConnection(view: UIViewController, errorName: String = "Connection Error") -> Bool {
        if NetworkService.isConnectedToInternet {
            return false
        } else {
            guard view.presentedViewController == nil else { return true }
            let network = networkError(errorName: errorName)
            view.present(network.alert, animated: true)
            return true
        }
    }
}
