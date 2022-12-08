//
//  ProfileViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 26/10/22.
//

import UIKit

protocol UpdateProfileDelegate {
    func update()
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var jobUser: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
        imageUser.clipsToBounds = true
        Profile.synchronize()
        nameUser.text = Profile.name
        jobUser.text = Profile.job
        imageUser.image = UIImage(data: Profile.image)
        nameUser.accessibilityIdentifier = "Name"
        jobUser.accessibilityIdentifier = "Job"
    }
    @IBAction func editProfile(_ sender: Any) {
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let editProfileGameViewController = storyboard.instantiateViewController(
            withIdentifier: EditProfileViewController.id) as? EditProfileViewController else {return}
        editProfileGameViewController.updateDelegate = self
        editProfileGameViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProfileGameViewController, animated: true)
    }
}

extension ProfileViewController: UpdateProfileDelegate {
    func update() {
        Profile.synchronize()
        nameUser.text = Profile.name
        jobUser.text = Profile.job
        imageUser.image = UIImage(data: Profile.image)
    }
}
