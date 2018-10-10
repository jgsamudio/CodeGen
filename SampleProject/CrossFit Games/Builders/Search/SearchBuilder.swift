//
//  SearchBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct SearchBuilder: Builder {

    // MARK: - Public Properties
    
    let leaderboard: CustomLeaderboard

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let searchViewController: SearchViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController()
        searchViewController.viewModel = SearchViewModel(customLeaderboard: leaderboard)
        return searchViewController
    }

}
