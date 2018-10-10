//
//  DoubleBorderedImageView.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// An image view with two borders that have spacing between them.
final class DoubleBorderedImageView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Color of outside border.
    var outerBorderColor: UIColor = .clear {
        didSet {
            layer.borderColor = outerBorderColor.cgColor
        }
    }
    
    /// Color of inner border.
    var innerBorderColor: UIColor = .clear {
        didSet {
            imageView.layer.borderColor = innerBorderColor.cgColor
        }
    }
    
    /// Image.
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    /// The corner radius of the view.
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            imageView.layer.cornerRadius = cornerRadius - borderSpacing
        }
    }
    
    /// Space between the inner and outer border.
    var borderSpacing: CGFloat = 0 {
        didSet {
            imageViewTopInset?.constant = borderSpacing
            imageViewBottomInset?.constant = -borderSpacing
            imageViewRightInset?.constant = -borderSpacing
            imageViewLeftInset?.constant = borderSpacing
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = theme.colorTheme.emphasisSecondary.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var imageViewTopInset: NSLayoutConstraint?
    
    private var imageViewBottomInset: NSLayoutConstraint?
    
    private var imageViewLeftInset: NSLayoutConstraint?
    
    private var imageViewRightInset: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    /// Creates an instance of double bordered image view.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Cancels network request to load image.
    func cancelImageRequest() {
        imageView.af_cancelImageRequest()
    }
    
    /// Makes network request for image from url and sets it.
    ///
    /// - Parameters:
    ///   - url: Image url.
    ///   - completion: Completion handler.
    func setImage(url: URL, completion: ((Bool) -> Void)? = nil) {
        imageView.loadImage(from: url) { (success) in
            completion?(success)
        }
    }
    
}

// MARK: - Private Functions
private extension DoubleBorderedImageView {
    
    func setupDesign() {
        layer.borderColor = theme.colorTheme.emphasisQuaternaryFaded.cgColor
        layer.borderWidth = 1
        setupImageView()
    }
    
    func setupImageView() {
        addSubview(imageView)
        imageViewTopInset = imageView.autoPinEdge(toSuperviewEdge: .top, withInset: borderSpacing)
        imageViewBottomInset = imageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: borderSpacing)
        imageViewLeftInset = imageView.autoPinEdge(toSuperviewEdge: .left, withInset: borderSpacing)
        imageViewRightInset = imageView.autoPinEdge(toSuperviewEdge: .right, withInset: borderSpacing)
    }
    
}
