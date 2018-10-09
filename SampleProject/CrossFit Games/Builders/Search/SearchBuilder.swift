//
//  SearchBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct SearchBuilder: Builder {

    let leaderboard: CustomLeaderboard

    func build() -> UIViewController {
        let searchViewController: SearchViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController()
        searchViewController.viewModel = SearchViewModel(customLeaderboard: leaderboard)
        return searchViewController
    }

}
