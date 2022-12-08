//
//  UIViewController+Ext.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 03/11/22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, action: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))

        present(alert, animated: true)
    }
}
