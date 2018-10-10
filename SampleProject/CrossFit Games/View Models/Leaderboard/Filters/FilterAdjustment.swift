//
//  FilterAdjustment.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Adjustment of filters for a filter view controller.
enum FilterAdjustment {

    case excludedFilters(names: [FilterName])

    case includedFilters(names: [FilterName])

    case expandedFilter(name: FilterName)

    case none

    // MARK: - Public Functions
    
    func filterOptions(adjusting filterViewModel: FilterViewModel) -> [FilterViewModelSelectionOption] {
        switch self {
        case .excludedFilters(names: let names):
            return filterViewModel.selectionOptions.filter({ (option) -> Bool in
                return !(names.map { $0.rawValue }.contains(option.filterName))
            })
        case .expandedFilter(name: let name):
            return filterViewModel.selectionOptions.first(where: { (option) -> Bool in
                option.filterName == name.rawValue
            }).flatMap({
                $0 as? FilterViewModelNestedOption
            })?.nestedOptions ?? []
        case .includedFilters(names: let names):
            return filterViewModel.selectionOptions.filter({ (option) -> Bool in
                return (names.map { $0.rawValue }.contains(option.filterName))
            })
        case .none:
            return filterViewModel.selectionOptions
        }
    }

}
