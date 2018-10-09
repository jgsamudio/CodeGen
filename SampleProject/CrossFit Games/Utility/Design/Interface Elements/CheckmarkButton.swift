//
//  CheckmarkButton.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class CheckmarkButton: UIButton {

    // MARK: - Private Properties
    
    private let checkedImage = UIImage(named: "checked")

    // MARK: - Public Properties
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                setBackgroundImage(checkedImage, for: .normal)
            } else {
                setBackgroundImage(UIImage(), for: .normal)
                backgroundColor = UIColor.white
            }
        }
    }

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
    }

    @objc private func pressButton(button: UIButton) {
        isChecked = !isChecked
    }

}
