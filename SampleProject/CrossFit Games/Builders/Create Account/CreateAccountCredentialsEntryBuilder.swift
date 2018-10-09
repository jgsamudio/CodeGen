//
//  CreateAccountCredentialsEntryBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct CreateAccountCredentialsEntryBuilder: Builder {

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "CreateAccountCredentialsEntry", bundle: nil)
        let viewController: CreateAccountCredentialsEntryViewController = storyboard.instantiateViewController()
        viewController.viewModel = CreateAccountCredentialsEntryViewModel()
        return viewController
    }
}
