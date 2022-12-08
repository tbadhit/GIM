//
//  UITableViewCell+Ext.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 28/10/22.
//

import UIKit

extension UITableViewCell {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
