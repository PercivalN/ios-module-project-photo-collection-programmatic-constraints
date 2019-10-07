//
//  PhotoDetailViewController.swift
//  PhotoCollection
//
//  Created by Spencer Curtis on 8/2/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: - Outlets
    var imageView: UIImageView!
    var titleTextField: UITextField!
	var addImageButton: UIButton!
    
    var photo: Photo?
    var photoController: PhotoController?
    var themeHelper: ThemeHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        updateViews()
		setupSubviews()
		initializeViews()
    }


	// MARK: - Setup subViews
	func setupSubviews() {

		let imageView = UIImageView()
		let addImageButton = UIButton()
		let titleTextField = UITextField()

		// Adds all the objects to the view at once
		view.addSubview(imageView)
		self.imageView = imageView
		view.addSubview(addImageButton)
		self.addImageButton = addImageButton
		view.addSubview(titleTextField)
		self.titleTextField = titleTextField

		// ImageView Constraints
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
		imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true


		// Add functionality to button
		addImageButton.translatesAutoresizingMaskIntoConstraints = false
		addImageButton.setTitle("Add Image", for: .normal)
		addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
		savePhoto()

		// addImage button constraints
		addImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
		addImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true


		titleTextField.translatesAutoresizingMaskIntoConstraints = false
		titleTextField.placeholder = "Give this photo a title:"

		// titleTextField constraints
		titleTextField.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20).isActive = true
		titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true

		let saveBarButton = UIBarButtonItem()
		saveBarButton.title = "Save Photos"

	}


    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image
    }
    
    // MARK: - Private Methods
    
	@objc private func addImage() {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
        default:
            break
        }
    }
    
    private func savePhoto() {
        
        guard let image = imageView.image,
            let imageData = image.pngData(),
            let title = titleTextField.text else { return }
        
        if let photo = photo {
            photoController?.update(photo: photo, with: imageData, and: title)
        } else {
            photoController?.createPhoto(with: imageData, title: title)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        
        guard let photo = photo else {
            title = "Create Photo"
            return
        }
        
        title = photo.title
        
        imageView.image = UIImage(data: photo.imageData)
        titleTextField.text = photo.title
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setTheme() {
        guard let themePreference = themeHelper?.themePreference else { return }
        
        var backgroundColor: UIColor!
        
        switch themePreference {
        case "Dark":
            backgroundColor = .lightGray
        case "Blue":
            backgroundColor = UIColor(red: 61/255, green: 172/255, blue: 247/255, alpha: 1)
        default:
            break
        }
        
        view.backgroundColor = backgroundColor
    }

	private func initializeViews() {
		addImageButton = UIButton()
		imageView = UIImageView()
		titleTextField = UITextField()
	}
}
