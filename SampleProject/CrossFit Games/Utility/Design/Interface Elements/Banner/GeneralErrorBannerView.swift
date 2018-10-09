//
//  GeneralErrorBannerView.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class GeneralErrorBannerView: UIView {

    @IBOutlet private weak var textLabel: StyleableLabel!

    /// Intanciate the view from the relavant nib file
    ///
    /// - Returns: General error banner view instance
    class func fromNib() -> GeneralErrorBannerView? {
        guard let bannerView = UINib(nibName: String(describing: GeneralErrorBannerView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? GeneralErrorBannerView else {
                return nil
        }
        return bannerView
    }

    /// Sets the title of the banner
    ///
    /// - Parameter title: title to be displayed in the banner
    func setTitle(title: String) {
        textLabel.text = title
    }
}
