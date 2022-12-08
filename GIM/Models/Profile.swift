//
//  Person.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 03/11/22.
//

import UIKit

struct Profile {
    static let firstLaunchKey = "first"
    static let nameKey = "name"
    static let jobKey = "job"
    static let imageKey = "image"

    static var first: Bool {
        get {
            return UserDefaults.standard.bool(forKey: firstLaunchKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: firstLaunchKey)
        }
    }

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    static var job: String {
        get {
            return UserDefaults.standard.string(forKey: jobKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: jobKey)
        }
    }

    static var image: Data {
        get {
            return UserDefaults.standard.data(forKey: imageKey) ?? imageToData("person")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageKey)
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }

    static func saveProfile(name: String, job: String, image: UIImage) {
        self.name = name
        self.job = job
        self.image = image.jpegData(compressionQuality: 1)!
    }

    static func addDummyProfile() {
        if !first {
            saveProfile(name: "Tubagus Adhitya Permana", job: "iOS Developer", image: #imageLiteral(resourceName: "profile"))
            first = true
        }
    }
}

func imageToData(_ title: String) -> Data {
    if let img = UIImage(named: title) {
        return img.jpegData(compressionQuality: 1)!
    }
    return #imageLiteral(resourceName: "broken_image").jpegData(compressionQuality: 1)!
}
