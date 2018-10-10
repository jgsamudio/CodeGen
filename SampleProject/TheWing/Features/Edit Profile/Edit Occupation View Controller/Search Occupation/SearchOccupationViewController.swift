//
//  SearchOccupationViewController.swift
//  TheWing
//
//  Created by Luna An on 4/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SearchOccupationViewController: BuildableViewController {
        
    // MARK: - Public Properties
    
    var viewModel: SearchOccupationViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    weak var delegate: EditOccupationViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.backgroundColor = colorTheme.tertiary
        borderView.autoSetDimension(.height, toSize: ViewConstants.lineSeparatorThickness)
        return borderView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.setCancelButton(textStyle: textStyleTheme.bodyLarge.withColor(colorTheme.errorPrimary))
        searchBar.setTextFieldColor(color: colorTheme.emphasisQuintary.withAlphaComponent(0.05))
        searchBar.backgroundImage = colorTheme.invertTertiary.image
        return searchBar
    }()
    
    private lazy var searchBarContainerView: UIView = {
        let containerView = UIView()
        containerView.autoSetDimension(.height, toSize: 53 + ViewConstants.navigationBarHeight)
        containerView.backgroundColor = colorTheme.invertTertiary
        view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        let insets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        tableView.layoutMargins =  insets
        tableView.separatorInset = insets
        tableView.registerCell(cellClass: SearchResultTableViewCell.self)
        tableView.registerCell(cellClass: SearchAddInputTableViewCell.self)
        view.addSubview(tableView)
        return tableView
    }()
    
    private let gutter = ViewConstants.defaultGutter

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

// MARK: - Private Functions
private extension SearchOccupationViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.invertTertiary
        setupSearchBar()
        setupSearchBarContainerView()
        setupTableView()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = viewModel.searchBarHelperText
        searchBar.becomeFirstResponder()
        searchBarContainerView.addSubview(searchBar)
        searchBar.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                                  left: ViewConstants.searchBarGutter,
                                                                  bottom: 7,
                                                                  right: ViewConstants.searchBarGutter),
                                               excludingEdge: .top)
    }
    
    func setupSearchBarContainerView() {
        searchBarContainerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        searchBarContainerView.addSubview(borderView)
        borderView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: searchBarContainerView, withOffset: 14)
    }
    
    func returnToSetSelection(selection: String?, type: SearchOccupationType) {
        delegate?.set(selection: selection, type: type)
        navigationController?.popViewController(animated: true)
    }
    
    func setupSearchReturnKey(type: SearchOccupationType) {
        searchBar.returnKeyType = .done
        if type == .companies {
            searchBar.enablesReturnKeyAutomatically = false
        }
    }
    
}

// MARK: - SearchOccupationViewDelegate
extension SearchOccupationViewController: SearchOccupationViewDelegate {
    
    func addSelection(selection: String, type: SearchOccupationType) {
        returnToSetSelection(selection: selection, type: type)
    }
    
    func showSearchResult(_ show: Bool) {
        tableView.isHidden = !show
    }
    
    func doneWithoutSelection() {
         returnToSetSelection(selection: nil, type: .companies)
    }
    
    func refreshResultsView() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension SearchOccupationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchOccupationSection.allSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SearchOccupationSection(rawValue: section) else {
            assertionFailure("Invalid search position section")
            return 0
        }
        
        switch section {
        case .searchResult:
            return viewModel.filteredResults.count
        case .userInput:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SearchOccupationSection(rawValue: indexPath.section) else {
            assertionFailure("Invalid search position section")
            return UITableViewCell()
        }
        
        switch section {
        case .searchResult:
            let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.layoutMargins = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
            cell.setup(theme: theme, result: viewModel.filteredResults[indexPath.row])
            return cell
        case .userInput:
            let cell: SearchAddInputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.setup(theme: theme, input: viewModel.userInput)
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SearchOccupationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SearchOccupationSection.searchResult.rawValue:
            viewModel.addUserSelection(searchResult: viewModel.filteredResults[indexPath.row])
        case SearchOccupationSection.userInput.rawValue:
            viewModel.addUserInput()
        default:
            return
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchOccupationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.validateSearchEntry(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.doneButtonPressed()
    }
    
}
