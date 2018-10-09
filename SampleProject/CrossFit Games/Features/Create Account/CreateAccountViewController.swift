//
//  CreateAccountViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!

    @IBOutlet private weak var passwordTextField: UITextField!

    @IBOutlet private weak var firstNameTextField: UITextField!

    @IBOutlet private weak var lastNameTextField: UITextField!

    @IBOutlet private weak var errorLabel: UILabel!

    var viewModel: CreateAccountViewModel!

    private let localization = PlaceholderLoginLocalization()

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.text = nil
    }

}
