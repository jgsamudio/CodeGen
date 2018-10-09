//
//  FullscreenLoadingView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

class FullscreenLoadingView: UIView {

    // MARK: - Public Functions
    
    /// Loads a dashboard loading view from nib and installs it as subview in the given view.
    ///
    /// - Parameter view: View to install the loading view in.
    /// - Returns: Created and installed view.
    static func install<T: FullscreenLoadingView>(in view: UIView, over: UIView? = nil) -> T {
        guard let loadingView = UINib(nibName: String(describing: T.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? T else {
                fatalError("Failed loading nib.")
        }
        loadingView.frame = view.bounds
        if let over = over {
            view.insertSubview(loadingView, aboveSubview: over)
        } else {
            view.addSubview(loadingView)
        }
        loadingView.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)

        return loadingView
    }

}
