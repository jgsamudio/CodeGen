//
//  EmptyDashboardCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EmptyDashboardCell: UICollectionViewCell {

    // MARK: - Private Properties
    
    @IBOutlet private weak var registerButton: StyleableButton!

    // MARK: - Public Properties
    
    var didTapRegister: () -> Void = {}

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 2
        registerButton.backgroundColor = .clear
        registerButton.layer.masksToBounds = true
    }

    @IBAction private func registerNow() {
        didTapRegister()
    }

}
