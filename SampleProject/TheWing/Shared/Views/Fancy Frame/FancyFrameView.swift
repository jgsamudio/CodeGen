//
//  FancyFrameView.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FancyFrameView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Fancy frame view delegate.
    weak var delegate: FancyFrameViewDelegate?
    
    /// Image to embed within fancy frame.
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    /// The corner radius of the embedded image view.
    var cornerRadius: CGFloat = 0 {
        didSet {
            imageView.cornerRadius = cornerRadius
        }
    }
    
    /// Property to show and hide the loading indicator.
    var isLoading: Bool = false {
        didSet {
            isLoading(isLoading)
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var fancyFrameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "fancy_frame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var imageView: DoubleBorderedImageView = {
        let imageView = DoubleBorderedImageView(theme: theme)
        imageView.backgroundColor = theme.colorTheme.emphasisTertiary
        imageView.innerBorderColor = theme.colorTheme.emphasisSecondary
        imageView.outerBorderColor = theme.colorTheme.emphasisSecondary
        imageView.borderSpacing = 4.5
        imageView.image = #imageLiteral(resourceName: "avatar")
        return imageView
    }()
    
    private lazy var loadingIndicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
    
    // MARK: - Initialization
    
    /// Creates an instance of double bordered image view.
    ///
    /// - Parameter theme: Theme.
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
        imageView.cancelImageRequest()
    }
    
    /// Makes network request for image from url and sets it.
    ///
    /// - Parameter url: Image url.
    func setImage(url: URL) {
        imageView.setImage(url: url) { (isLoaded) in
            self.delegate?.imageLoaded(isLoaded)
        }
    }
    
    /// Sets the profile image with a chosen image.
    ///
    /// - Parameters:
    ///   - image: UIImage.
    ///   - completion: Completion handler.
    func setImage(with image: UIImage, completion: (() -> Void)? = nil) {
        imageView.image = image
        completion?()
    }

}

// MARK: - Private Functions
private extension FancyFrameView {
    
    func setupDesign() {
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraitImage
        setupImageView()
        setupFancyFrame()
        setupLoadingIndicator()
    }
    
    func isLoading(_ loading: Bool) {
        UIView.animate(withDuration: AnimationConstants.loadingIndicatorDuration, animations: {
            self.imageView.alpha = loading ? 0 : 1
        })
        loadingIndicator.isLoading(loading: loading)
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 4)
        imageView.autoMatch(.width, to: .height, of: imageView)
    }
    
    private func setupFancyFrame() {
        addSubview(fancyFrameImageView)
        fancyFrameImageView.autoPinEdgesToSuperviewEdges()
        imageView.autoAlignAxis(.vertical, toSameAxisOf: fancyFrameImageView)
    }
    
    private func setupLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.autoAlignAxis(.vertical, toSameAxisOf: imageView)
        loadingIndicator.autoAlignAxis(.horizontal, toSameAxisOf: imageView)
    }
    
}
