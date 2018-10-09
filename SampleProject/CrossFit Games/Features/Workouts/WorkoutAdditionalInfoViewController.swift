//
//  WorkoutAdditionalInfoViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class WorkoutAdditionalInfoViewController: BaseViewController {

    @IBOutlet private var informationLabel: StyleableLabel!

    var content: NSAttributedString?

    override func viewDidLoad() {
        super.viewDidLoad()
        informationLabel.attributedText = content
    }

}
