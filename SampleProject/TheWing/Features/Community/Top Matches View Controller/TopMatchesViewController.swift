//
//  TopMatchesViewController.swift
//  TheWing
//
//  Created by Luna An on 8/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TopMatchesViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    var viewModel: TopMatchesViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.registerCell(cellClass: MemberTableViewCell.self)
        tableView.backgroundColor = colorTheme.invertPrimary
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var activityIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        indicator.frame = ViewConstants.loadingIndicatorFooterFrame
        return indicator
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadTopMatches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.layer.shadowOpacity = tableView.navigationShadowOpacity
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.layer.shadowOpacity = 0
    }
    
}

// MARK: - Private Functions
private extension TopMatchesViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.secondary
        setupTableView()
        setupNavigationBar()
        setupNavigationBarUnderline()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .top, of: view, withOffset: 1)
    }
    
    func setLoadingIndicator(loading: Bool) {
        activityIndicator.isLoading(loading: loading)
        tableView.tableFooterView = loading ? activityIndicator : nil
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_button"), style: .plain, target: self, action: #selector(backButtonSelected))
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.clipsToBounds = false
        navigationController?.setNavigationBar(backgroundColor: colorTheme.invertTertiary,
                                               tintColor: colorTheme.emphasisQuintary,
                                               textStyle: textStyleTheme.headline3)
        navigationController?.addDropShadow(color: colorTheme.emphasisQuintary,
                                            offset: ViewConstants.navigationBarShadowOffset,
                                            radius: ViewConstants.navigationBarShadowRadius)
    }
    
    private func setupNavigationBarUnderline() {
        let underline = UIView.dividerView(height: 1, color: colorTheme.tertiary)
        view.addSubview(underline)
        underline.autoPinEdge(.leading, to: .leading, of: view)
        underline.autoPinEdge(.trailing, to: .trailing, of: view)
        underline.autoPinEdge(.top, to: .top, of: view)
    }
    
    @objc func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension TopMatchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topMatchesMemberInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let memberInfo = viewModel.topMatchesMemberInfo[safe: indexPath.row] {
            cell.setup(theme: theme, memberInfo: memberInfo, category: .all)
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension TopMatchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memberInfo = viewModel.topMatchesMemberInfo[indexPath.row]
        analyticsProvider.track(event: AnalyticsEvents.Community.didSelectProfile.analyticsIdentifier,
                                properties: memberInfo.analyticsProperties(forScreen: self),
                                options: nil)
        let viewController = builder.profileViewController(userId: memberInfo.userId, partialMemberInfo: memberInfo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - TopMatchesViewDelegate
extension TopMatchesViewController: TopMatchesViewDelegate {
    
    func isLoading(_ loading: Bool) {
        setLoadingIndicator(loading: loading)
    }
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    func displayError(error: Error?) {
        presentAlertController(withNetworkError: error)
    }

}

// MARK: - UIScrollViewDelegate
extension TopMatchesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.layer.shadowOpacity = scrollView.navigationShadowOpacity
        if scrollView.scrolledPastThreshold(ViewConstants.paginateScrollPercentage) {
            viewModel.loadTopMatches()
        }
    }
    
}

// MARK: - AnalyticsIdentifiable
extension TopMatchesViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.topMatches.analyticsIdentifier
    }
    
}
