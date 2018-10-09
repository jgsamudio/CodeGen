//
//  SearchViewModel.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct SearchViewModel {

    // MARK: - Private Properties
    
    private let service = ServiceFactory.shared.createLeaderboardSearchService()
    private let textDebouncer = TextDebouncer()
    private let customLeaderboard: CustomLeaderboard
    
    // MARK: - Public Properties
    
    var leaderboardSearchResults = [LeaderboardSearch]() {
        didSet {
            leaderboardSearchResults =  leaderboardSearchResults.sorted(by: { $0.lastname < $1.lastname })
        }
    }

    /// Title of Filter
    var filterTitle: String {
        var competition: String? = customLeaderboard.selectedControls.name
        let fittestSelection: String?

        let configName = (competition == "Regionals" ? "regional" : "fittest")
        switch customLeaderboard.filterSelection.first (where: { $0.filter.configName == configName }) {
        case .some(LeaderboardFilterSelection.multiSelect(filter: _, selection: _, nestedSelection: let selection)):
            fittestSelection = selection.display
        case .some(LeaderboardFilterSelection.defaultSelection(filter: _, selection: let selection)):
            fittestSelection = selection.display
            competition = nil
        default:
            fittestSelection = nil
        }
        let divisionSelection = customLeaderboard.filterSelection.first (where: { $0.filter.configName == "division" })?.selection.display
        let filters = [competition, fittestSelection, divisionSelection].flatMap ({ $0 }).joined(separator: ", ")
        return GeneralLocalization().inString(suffix: filters)
    }

    // MARK: - Initialization
    
    /// Initalizer
    ///
    /// - Parameter customLeaderboard: CustomLeaderboard to initalize
    init(customLeaderboard: CustomLeaderboard) {
        self.customLeaderboard = customLeaderboard
    }

    // MARK: - Public Functions
    
    /// Search to trigger network request (internally uses debouncer)
    ///
    /// - Parameters:
    ///   - text: String to use for network call
    ///   - completion: Results from network response
    func search(text: String?, completion: @escaping ([LeaderboardSearch]?, Error?) -> Void) {
        guard let text = text else {
            return
        }
        textDebouncer.trigger(text: text, delay: 0.3) {
            self.service.getLeaderboardFilters(text: text, customLeaderBoard: self.customLeaderboard, completion: completion)
        }
    }

    /// Navigates to the leaderboard
    ///
    /// - Parameters:
    ///   - tabBarController: Tab bar controller used to switch tabs appropriately.
    ///   - indexPath: IndexPath specifying which data source to open leaderboard
    ///   - completion: Completion Handler to use once presentation is complete
    func navigateToLeaderboard(switchingTabIn tabBarController: UITabBarController?,
                               for indexPath: IndexPath,
                               completion: @escaping (() -> Void)) {
        let router = LeaderboardPresentationRouter.switchingTabsIn(tabBarController: tabBarController)
        let userId = leaderboardSearchResults[indexPath.row].identifier
        router.present(leaderboard: customLeaderboard, searchingAthlete: userId, onPage: nil, completion: completion)
    }

}
