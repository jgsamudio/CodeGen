//
//  RefreshControlView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class RefreshControlView: UIView {

    // MARK: - Public Properties

    weak var delegate: RefreshControlDelegate?

    private(set) var refreshLabel = UILabel()

    private(set) var bottomImageView = UIImageView()

    // MARK: - Private Properties

    private let loadingIndicator: LoadingIndicator

    private var heightConstraint: NSLayoutConstraint?

    private var isLoading = false

    // MARK: - Constants

    private static let loadingHeight: CGFloat = 83

    private static let bottomOffset: CGFloat = -16

    // MARK: - Initialization

    init(indicatorColor: UIColor? = nil) {
        loadingIndicator = LoadingIndicator(activityIndicatorViewStyle: .gray, indicatorColor: indicatorColor)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Called when the scroll view scrolls.
    ///
    /// - Parameter scrollView: Current scroll view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateComponents(height: max(-scrollView.contentOffset.y, 0))
    }

    /// Called when the scroll view ends dragging.
    ///
    /// - Parameter scrollView: Current scrollview.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        guard !isLoading, scrollView.contentOffset.y < -RefreshControlView.loadingHeight else {
            return
        }
        scrollView.contentInset = UIEdgeInsets(top: RefreshControlView.loadingHeight, left: 0, bottom: 0, right: 0)
        isLoading = true
        updateLoadingIndicator()
        delegate?.reload()
    }

    /// Sets the view into a loading state.
    ///
    /// - Parameters:
    ///   - loading: Determines if the view is loading.
    ///   - scrollView: Current scrollview.
    func setIsLoading(_ loading: Bool, scrollView: UIScrollView) {
        isLoading = loading
        updateLoadingIndicator()
        guard !isLoading else {
            return
        }
        
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            scrollView.contentInset = .zero
            scrollView.setContentOffset(.zero, animated: true)
        })
    }

}

// MARK: - Private Functions
private extension RefreshControlView {

    func setupView() {
        heightConstraint = autoSetDimension(.height, toSize: 0)
        clipsToBounds = true
        
        addSubview(refreshLabel)
        refreshLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
        refreshLabel.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: RefreshControlView.bottomOffset / 2)

        addSubview(bottomImageView)
        bottomImageView.autoAlignAxis(.vertical, toSameAxisOf: self)
        bottomImageView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: RefreshControlView.bottomOffset)

        addSubview(loadingIndicator)
        loadingIndicator.autoAlignAxis(.vertical, toSameAxisOf: self)
        loadingIndicator.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: RefreshControlView.bottomOffset / 2)

        updateComponents(height: 0)
    }

    func updateComponents(height: CGFloat) {
        heightConstraint?.constant = height

        let alpha = min(height, RefreshControlView.loadingHeight) / RefreshControlView.loadingHeight
        refreshLabel.alpha = isLoading ? 0 : alpha
        bottomImageView.alpha = alpha
    }

    func updateLoadingIndicator() {
        loadingIndicator.isLoading(loading: isLoading)
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.loadingIndicator.alpha = self.isLoading ? 1 : 0
        })
    }

}
