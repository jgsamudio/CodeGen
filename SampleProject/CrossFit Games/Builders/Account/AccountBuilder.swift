//
//  AccountBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builds Account Flow
struct AccountBuilder: Builder {

    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let accountViewController: AccountViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController()
        accountViewController.viewModel = AccountViewModel()
        return accountViewController
    }

}
