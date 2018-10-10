//
//  LoadingIndicator.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class LoadingIndicator: UIView {

    // MARK: - Private Properties

    private var loadingIndicator: UIActivityIndicatorView?
    private let activityIndicatorViewStyle: UIActivityIndicatorViewStyle
    private let indicatorColor: UIColor?

    // MARK: - Initialization

    init(activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .white, indicatorColor: UIColor? = nil) {
        self.activityIndicatorViewStyle = activityIndicatorViewStyle
        self.indicatorColor = indicatorColor
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Shows the loading indicator with the parameter provided.
    ///
    /// - Parameter loading: Determines if there is a network request occuring.
    func isLoading(loading: Bool) {
        if loading {
            addLoadingIndicatorIfNeeded()
            showLoadingIndicator(show: true)
        } else {
            showLoadingIndicator(show: false, completion: { (_) in
                self.hideLoadingIndicator()
            })
        }
    }
    
}

// MARK: - Private Functions
private extension LoadingIndicator {

    func addLoadingIndicatorIfNeeded() {
        if let indicator = loadingIndicator {
            addLoadingIndicator(indicator: indicator)
        } else {
    
    // MARK: - Public Properties
    
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorViewStyle)
            indicator.color = indicatorColor
            loadingIndicator = indicator
            addLoadingIndicator(indicator: indicator)
        }
    }

    func showLoadingIndicator(show: Bool, completion: ((Bool) -> Void)? = nil) {
        self.loadingIndicator?.alpha = show ? 0 : 1
        UIView.animate(withDuration: AnimationConstants.loadingIndicatorDuration, animations: {
            self.loadingIndicator?.alpha = show ? 1 : 0
        }, completion: completion)
    }

    func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
    }
    
    private func addLoadingIndicator(indicator: UIActivityIndicatorView) {
        addSubview(indicator)
        indicator.autoCenterInSuperview()
        indicator.startAnimating()
    }

}
