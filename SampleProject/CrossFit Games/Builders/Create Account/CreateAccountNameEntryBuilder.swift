//
//  CreateAccountBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct CreateAccountNameEntryBuilder: Builder {

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "CreateAccountNameEntry", bundle: nil)
        let viewController: CreateAccountNameEntryViewController = storyboard.instantiateViewController()
        viewController.viewModel = CreateAccountNameEntryViewModel()
        return viewController
    }
}
