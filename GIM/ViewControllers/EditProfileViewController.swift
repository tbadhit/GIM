//
//  EditProfileViewController.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 03/11/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    static let id = "EditProfileViewController"
    @IBOutlet weak var removePhotoButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var jobField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var updateDelegate: UpdateProfileDelegate?
    private let imagePicker = UIImagePickerController()
    private var keyboardSize: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        Profile.synchronize()
        nameField.text = Profile.name
        jobField.text = Profile.job
        profileImage.image = UIImage(data: Profile.image)
        checkIsTextEmpty()
        if Profile.image == #imageLiteral(resourceName: "profile").jpegData(compressionQuality: 1) {
            removePhotoButton.isEnabled = false
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    @IBAction func jobFieldChanged(_ sender: Any) {
        checkIsTextEmpty()
    }
    @IBAction func nameFieldChanged(_ sender: Any) {
        checkIsTextEmpty()
    }
    @IBAction func choosePhoto(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func removePhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Remove Photo", message: "Are you sure?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(named: "noImage")
                self.removePhotoButton.isEnabled = false
            }
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        if let name = nameField.text, let job = jobField.text, let image = profileImage.image {
            Profile.saveProfile(name: name, job: job, image: image)
            updateDelegate?.update()
            navigationController?.popViewController(animated: true)
        }
    }
    private func checkIsTextEmpty() {
        if let name = nameField.text, let job = jobField.text {
            if name.isEmpty || job.isEmpty {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EditProfileViewController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardHeight = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue
            .height,
           let scrollView = scrollView {
            UIView.animate(
                withDuration: CATransaction.animationDuration(),
                animations: {
                    scrollView.contentInset = UIEdgeInsets(
                        top: 0, left: 0, bottom: keyboardHeight, right: 0)
                }
            )
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let scrollView = scrollView {
            UIView.animate(
                withDuration: CATransaction.animationDuration(),
                animations: { scrollView.contentInset = .zero }
            )
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = result
            removePhotoButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Failed", message: "Image can't be loaded", action: "Dismiss")
        }
    }
}
