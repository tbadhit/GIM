//
//  UITableView+Ext.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 28/10/22.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String, color: UIColor) {
        let messageLabel = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.size.width,
                height: self.bounds.size.height)
        )
        messageLabel.text = message
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
