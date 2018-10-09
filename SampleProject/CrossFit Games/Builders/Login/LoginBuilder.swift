//
//  LoginBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct LoginBuilder: Builder {

    // MARK: - Private Properties
    
    private let loginCompletion: ((LoginEvent) -> Void)?

    // MARK: - Initialization
    
    init(loginCompletion: ((LoginEvent) -> Void)? = nil) {
        self.loginCompletion = loginCompletion
    }
    
    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        viewController.viewModel = LoginViewModel()
        if let loginCompletion = loginCompletion {
            viewController.loginCompletion = loginCompletion
        }
        return viewController
    }
}
