//
//  ProfileEditVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 18.06.2022.
//

import UIKit

class ProfileEditVC: UIViewController {

    @IBOutlet private weak var profileImage: CustomImageView!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var bioField: UITextView!
    
    private var storage = StorageService.shared
    private var viewModel: UserViewModel
    
//MARK: - Custom init
    
    init?(coder: NSCoder, viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configureUI()
    }
    
    func configureUI() {
        profileImage.setImage(url: viewModel.userImageUrl)
        usernameField.text = viewModel.userName
        emailField.text = viewModel.user.email
        bioField.text = viewModel.userBio
        bioField.layer.cornerRadius = 10.0
        bioField.layer.borderWidth = 1.0
        bioField.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func updateTapped(_ sender: Any) {
        
        guard let userImageURL = viewModel.userImageUrl,
              let newImage = profileImage.image
        else { return }
            
        if !profileImage.isSame(with: userImageURL) {
            storage.imageUpload(to: .userImages, id: viewModel.userId, image: newImage) { imageURL in
                self.updateUserInfo()
                self.viewModel.user.userImageUrl = imageURL
                self.viewModel.updateUser()
            }
        } else {
            updateUserInfo()
            self.viewModel.updateUser()
        }
        presentAlert(title: "Status", message: "Profile Updated") { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func updateUserInfo() {
        
        if self.usernameField.text != self.viewModel.userName ||
            self.bioField.text != self.viewModel.userBio
        {
            self.viewModel.user.bio = self.bioField.text
            guard let newUsername = self.usernameField.text else { return }
            AuthManager.shared.changeUsername(with: newUsername)
            self.viewModel.user.userName = newUsername
            self.viewModel.user.userNameLowercased = newUsername.lowercased()
        }
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let updatePasswordVC = PasswordVC()
        updatePasswordVC.modalPresentationStyle = .overCurrentContext
        updatePasswordVC.modalTransitionStyle = .crossDissolve
        present(updatePasswordVC, animated: true)
    }
    
}

// MARK: - ImagePicker Delegate

extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImagePicker() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(gesture)
        profileImage.isUserInteractionEnabled = true
    }

    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
