//
//  PhotoCollectionViewCell.swift
//  PhotoCollection
//
//  Created by Spencer Curtis on 8/2/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

	private var imageView: UIImageView!
	private var nameLabel: UILabel!

	var photo: Photo? {
		didSet {
		}
	}

	// To programmtically initialize cell
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}

	// The storyboard and xib initializing the cell
	required init?(coder: NSCoder) {
		super .init(coder: coder)!
		setupSubviews()
	}

	private func setupSubviews() {

		// Create image and setup constraints
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit

		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
			imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
			])

		self.imageView = imageView

		// Create lable and setup constraints
		let label = UILabel()
		label.textAlignment = .center

		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2)
			])

		self.nameLabel = label
	}
    
	private func updateViews() {
		guard let photo = photo else { return }
		imageView.image = UIImage(data: photo.imageData)
		nameLabel.text = photo.title
	}
}
