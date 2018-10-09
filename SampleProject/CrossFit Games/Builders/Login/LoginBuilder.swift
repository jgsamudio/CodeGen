//
//  LoginBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct LoginBuilder: Builder {

    private let loginCompletion: ((LoginEvent) -> Void)?

    init(loginCompletion: ((LoginEvent) -> Void)? = nil) {
        self.loginCompletion = loginCompletion
    }

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        viewController.viewModel = LoginViewModel()
        if let loginCompletion = loginCompletion {
            viewController.loginCompletion = loginCompletion
        }
        return viewController
    }
}
