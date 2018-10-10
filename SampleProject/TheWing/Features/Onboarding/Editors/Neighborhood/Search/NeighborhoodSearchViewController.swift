//
//  NeighborhoodSearchViewController.swift
//  TheWing
//
//  Created by Paul Jones on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class NeighborhoodSearchViewController: BuildableViewController {
    
    // MARK: - Public Properties

    var viewModel: NeighborhoodSearchViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    weak var delegate: NeighborhoodSearchViewControllerDelegate?

    // MARK: - Private Properties

    private lazy var searchBarContainerView: UIView = {
        let containerView = UIView()
        containerView.autoSetDimension(.height, toSize: 53)
        return containerView
    }()
    
    private lazy var headlineLabel: UILabel = UILabel(text: NeighborhoodSearchLocalization.title,
                                                      using: textStyleTheme.headline4,
                                                      with: colorTheme.emphasisQuintary)
    
    private lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.backgroundColor = colorTheme.tertiary
        return borderView
    }()
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.layoutMargins =  UIEdgeInsets(top: 14,
                                                left: ViewConstants.defaultGutter,
                                                bottom: 0,
                                                right: ViewConstants.defaultGutter)
        tableView.separatorInset = ViewConstants.defaultInsets
        tableView.tableFooterView = UIView()
        tableView.registerCell(cellClass: SearchResultTableViewCell.self)
        return tableView
    }()

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraintsAndSubviews()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - Private Functions
private extension NeighborhoodSearchViewController {
    
    func setupConstraintsAndSubviews() {
        view.backgroundColor = colorTheme.invertTertiary
        navigationItem.setHidesBackButton(true, animated: true)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        let textStyle = textStyleTheme.bodyLarge.withColor(colorTheme.errorPrimary)
        searchBar.setCancelButton(textStyle: textStyle)
        searchBar.setTextFieldColor(color: colorTheme.emphasisQuintary.withAlphaComponent(0.05))
        searchBar.backgroundImage = colorTheme.invertTertiary.image
        
        view.addSubview(headlineLabel)
        headlineLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 35)
        headlineLabel.autoPinEdge(toSuperviewEdge: .left,
                                  withInset: ViewConstants.defaultGutter,
                                  relation: .greaterThanOrEqual)
        headlineLabel.autoPinEdge(toSuperviewEdge: .right,
                                  withInset: ViewConstants.defaultGutter,
                                  relation: .greaterThanOrEqual)
        headlineLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        view.addSubview(searchBarContainerView)
        searchBarContainerView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        searchBarContainerView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        searchBarContainerView.autoPinEdge(.top, to: .bottom, of: headlineLabel, withOffset: 15)
        searchBarContainerView.backgroundColor = colorTheme.invertTertiary
        
        searchBarContainerView.addSubview(searchBar)
        let insets = UIEdgeInsets(top: 8,
                                  left: ViewConstants.searchBarGutter,
                                  bottom: 7,
                                  right: ViewConstants.searchBarGutter)
        searchBar.autoPinEdgesToSuperviewEdges(with: insets)
        
        searchBarContainerView.addSubview(borderView)
        borderView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        borderView.autoSetDimension(.height, toSize: ViewConstants.lineSeparatorThickness)
        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: searchBarContainerView, withOffset: 0)
    }
    
}

// MARK: - UITableViewDataSource
extension NeighborhoodSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.layoutMargins = ViewConstants.defaultInsets
        cell.setup(theme: theme, result: viewModel.results[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension NeighborhoodSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        delegate?.neighborhoodSearchViewController(self, didSelectNeighborhood: viewModel.results[indexPath.row])
    }
    
}

// MARK: - UISearchBarDelegate
extension NeighborhoodSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.neighborhoodSearchViewControllerCancelTouchUpInside(self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(with: searchText)
    }
    
}

// MARK: - NeighborhoodSearchViewDelegate
extension NeighborhoodSearchViewController: NeighborhoodSearchViewDelegate {
    
    func refresh() {
        tableView.reloadAllSections()
    }
    
}
