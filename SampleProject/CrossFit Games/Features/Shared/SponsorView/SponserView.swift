//
//  SponserView.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

private struct Constants {

    // MARK: - Public Properties
    
    static let airrostiLogoURL = "https://www.airrosti.com/"
    static let reebokLogoURL = "https://www.reebok.com/us/"
    static let rogueURL = "https://www.roguefitness.com/"
    
}

/// Displays Sponser View
final class SponserView: UIView {

    // MARK: - Private Properties
    
    /// Handles callbacks for `SponsorView`
    @IBOutlet private weak var delegate: SponsorViewDelegate?

    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupForStoryboardUse()
    }

    @IBAction private func tappedAirrostiLogo(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: Constants.airrostiLogoURL) {
            delegate?.tappedLogo(url: url)
        }
    }

    @IBAction private func tappedReebokLogo(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: Constants.reebokLogoURL) {
            delegate?.tappedLogo(url: url)
        }
    }

    @IBAction private func tappedRogueLogo(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: Constants.rogueURL) {
            delegate?.tappedLogo(url: url)
        }
    }

}
