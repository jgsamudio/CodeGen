//
//  FilterViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller for selecting leaderboard filters or a subset of filters (such as only sort filters or content of a
/// nested filter like "Competition").
final class FilterViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: FilterViewModel!

    /// Applies a "Theme" to the view controller so that the screen can be blue, white or whatever other
    /// color, as well as to customize font attributes.
    var themeConfig: FilterThemeConfiguration!

    /// Adjusts filter in the view model to remove specific filters of expand one particular filter.
    var filterAdjustment: FilterAdjustment!

    /// View controller used to present `self`. Will be updated if selections are made on `self`.
    weak var presentingFilterViewController: FilterViewController?

    /// Custom title that is used instead of the view model's provided title.
    var customTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            navBar.shadowImage = UIImage()
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.tintColor = themeConfig.barButtonTintColor
            navBar.titleTextAttributes = themeConfig.titleAttributes
            if #available(iOS 11.0, *) {
                navBar.prefersLargeTitles = themeConfig.shouldUseLargeTitles
                navBar.largeTitleTextAttributes = themeConfig.largeTitleAttributes
                if navigationController?.viewControllers.dropFirst().isEmpty == false {
                    navigationItem.largeTitleDisplayMode = .never
                } else {
                    navigationItem.largeTitleDisplayMode = .always
                }
            }
        }

        tableView.dataSource = self
        tableView.delegate = self

        view.backgroundColor = themeConfig.backgroundColor
        tableView.backgroundColor = themeConfig.backgroundColor
        tableView.sectionIndexColor = themeConfig.barButtonTintColor
        tableView.sectionIndexBackgroundColor = themeConfig.backgroundColor
        title = customTitle ?? viewModel.title
    }

    /// Reloads data.
    func reload() {
        tableView.reloadData()
        presentingFilterViewController?.reload()
    }

    private func viewModelIndex(for indexPath: IndexPath) -> Int {
        if viewModel.shouldGroupContentAlphabetically {
            return indexPath.section
        } else {
            return indexPath.row
        }
    }

    /// Dismisses `self`.
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    /// Resets filters on `self`.
    @objc func reset() {
        viewModel.reset()
        reload()
    }

}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.shouldGroupContentAlphabetically {
            return filterAdjustment.filterOptions(adjusting: viewModel).count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.shouldGroupContentAlphabetically {
            return 1
        } else {
            return filterAdjustment.filterOptions(adjusting: viewModel).count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionOption = filterAdjustment.filterOptions(adjusting: viewModel)[viewModelIndex(for: indexPath)]
        switch selectionOption {
        case let val as FilterViewModelNestedOption:
            let cell: FilterNestedSelectionCell = tableView.dequeueCell(forIndexPath: indexPath)
            cell.config = themeConfig
            cell.name = val.title
            cell.selectedOptionName = val.selectedOption()
            return cell
        default:
            let cell: FilterSingleSelectionCell = tableView.dequeueCell(forIndexPath: indexPath)
            cell.config = themeConfig
            cell.name = selectionOption.title
            cell.isSelected = selectionOption.isSelected()
            return cell
        }
    }

}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = viewModelIndex(for: indexPath)
        filterAdjustment.filterOptions(adjusting: viewModel)[index].didSelect()

        if let nestedOption = filterAdjustment.filterOptions(adjusting: viewModel)[index] as? FilterViewModelNestedOption {
            let newViewController = FilterBuilder(themeConfig: themeConfig,
                                                  viewModel: LeaderboardNestedFilterViewModel(nestedOption: nestedOption),
                                                  addBarButtons: false,
                                                  filterAdjustment: .none,
                                                  presentingViewController: self,
                                                  customTitle: nil).build()
            navigationController?.pushViewController(newViewController, animated: true)
        }
        reload()
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndices
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.selectionOptions.index(where: { (option) -> Bool in
            option.title.first.flatMap(String.init) == title
        }) ?? 0
    }

    private var sectionIndices: [String]? {
        guard viewModel.shouldGroupContentAlphabetically else {
            return nil
        }
        let initials = viewModel.selectionOptions.flatMap { $0.title.first.flatMap(String.init) }
        return initials.reduce([String](), { (result, element) -> [String] in
            var result = result
            if !result.contains(element) {
                result.append(element)
            }
            return result
        })
    }

}

// MARK: - TabBarTappable
extension FilterViewController: TabBarTappable {

    func handleTabBarTap() {
        cancel()
    }

}
