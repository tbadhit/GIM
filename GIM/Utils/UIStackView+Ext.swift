//
//  UIStackView+Ext.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 03/11/22.
//

import UIKit

extension UIStackView {
    func generatePlatformLogo(
        parentPlatformNames: Set<String>?) {
        let platformList: Set<String> = [
            "pc",
            "playstation",
            "xbox",
            "ios",
            "android",
            "mac",
            "linux",
            "nintendo",
            "web"
        ]
        var platformLogo = [String]()

        parentPlatformNames?.forEach { platform in
            let platform = platform.lowercased()

            platformList.forEach { platformName in
                var logo = platformName.lowercased()

                if platform.contains(logo) {
                    if logo == "pc" {
                        logo = "windows"
                    }

                    guard !platformLogo.contains(logo) else { return }
                    platformLogo.append(logo)
                }
            }
        }

        if let parentPlatforms = parentPlatformNames, !parentPlatforms.subtracting(platformList).isEmpty {
            platformLogo.append("more")
        }

        self.subviews.forEach({ $0.removeFromSuperview() })
        var logoBefore: UIImageView?
        var logoCount = 1

        platformLogo.forEach { logo in
            var logo = logo
            if logoCount > 10 - 1 {
                logo = "more"
            }

            guard logoCount <= 10 else { return }
            let logoImage = UIImageView(image: UIImage(named: logo))
            self.addSubview(logoImage)
            logoCount += 1

            let widthConstraint = NSLayoutConstraint(
                item: logoImage,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: 25)
            let heightConstraint = NSLayoutConstraint(
                item: logoImage,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: 25)
            let verticalConstraint = NSLayoutConstraint(
                item: logoImage,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0)
            var constraint = [
                widthConstraint,
                heightConstraint,
                verticalConstraint
            ]

            if logoBefore != nil {
                constraint.append(logoImage.leadingAnchor.constraint(equalTo: logoBefore!.trailingAnchor, constant: 10))
            }

            logoImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(constraint)
            logoBefore = logoImage
        }
    }
}
