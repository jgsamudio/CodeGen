//
//  EditProfilePhotoView.swift
//  TheWing
//
//  Created by Luna An on 4/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Edit profile's edit profile photo view.
final class EditProfilePhotoView: UIView {
    
    // MARK: - Public Properties
    
    /// Edit profile photo view delegate.
    weak var delegate: EditProfilePhotoViewDelegate?
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private lazy var imageView: DoubleBorderedImageView = {
        let imageSize = EditProfilePhotoView.imageSize
        let imageView = DoubleBorderedImageView(theme: theme)
        imageView.autoSetDimensions(to: imageSize)
        imageView.borderSpacing = 2.5
        imageView.cornerRadius = imageSize.height / 2
        imageView.image = #imageLiteral(resourceName: "avatar")
        return imageView
    }()
    
    private lazy var editPhotoButton: UIButton = {
        let editPhotoButton = UIButton()
        var textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.emphasisPrimary).withStrongFont()
        editPhotoButton.setTitleText("EDIT_PHOTO".localized(comment: "Edit Photo title"), using: textStyle)
        editPhotoButton.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        editPhotoButton.sizeToFit()
        return editPhotoButton
    }()
    
    // MARK: - Constants
    
    private static let imageSize = CGSize(width: 80, height: 80)
    
    // MARK: - Initialization
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the profile image with a URL.
    ///
    /// - Parameter imageURL: The image URL if available.
    func setImage(with string: String?) {
        guard let photo = string, let url = URL(string: photo) else {
            imageView.image = #imageLiteral(resourceName: "avatar")
            return
        }
        
        imageView.setImage(url: url)
    }
    
    /// Sets the profile image with a chosen image.
    ///
    /// - Parameter image: UIImage.
    func setImage(with image: UIImage, completion: () -> Void ) {
        imageView.image = image
        delegate?.setNewAvatar(newAvatar: image)
        completion()
    }
    
}

// MARK: - Private Functions
private extension EditProfilePhotoView {
    
    func setupDesign() {
        autoSetDimension(.height, toSize: 122)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(imageView)
        addSubview(editPhotoButton)
        
        imageView.autoPinEdge(.top, to: .top, of: self, withOffset: 13)
        imageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 32)
        
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 16)
        editPhotoButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -4).isActive = true
    }
    
    @objc func editPhoto() {
        delegate?.editPhoto()
    }
    
}
