//
//  DashboardStatsViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

final class DashboardStatsViewController: BaseViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var percentileProgressView: UIProgressView!
    @IBOutlet private weak var percentileView: UIView!
    @IBOutlet private weak var percentileLabel: StyleableLabel!
    @IBOutlet private weak var overallRankView: UIView!
    @IBOutlet private weak var totalAthletesLabel: StyleableLabel!
    @IBOutlet private weak var athleteRankLabel: StyleableLabel!
    @IBOutlet private weak var overallRankLabel: StyleableLabel!
    @IBOutlet private weak var percentileValueLabel: StyleableLabel!
    @IBOutlet private weak var viewLeaderboardButton: StyleableButton!
    @IBOutlet private weak var openNotStartedView: UIView!
    @IBOutlet private weak var openNotStartedLabel: UILabel!
    @IBOutlet private weak var workoutStatsTableView: UITableView!
    @IBOutlet private weak var overallRankSlash: UIImageView!
    private var workoutStats: [WorkoutStatsViewModel] = []

    private weak var loadingView: DashboardStatsLoadingView?

    // MARK: - Public Properties
    
    var viewModel: DashboardStatsViewModel? {
        didSet {
            (parent as? CardDetailContainerViewController)?.updateTitles()
            title = viewModel?.title

            guard isViewLoaded else {
                return
            }
            config()
        }
    }

    private let localization = DashboardStatsLocalization()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    @IBAction private func showLeaderboard() {
        if let title = viewModel?.title {
            Simcoe.track(event: .dashboardCardViewThisLeaderboard,
                         withAdditionalProperties: [.dashboardCard: title], on: .dashboard)
        }
        viewModel?.navigateToLeaderboard(pushIn: navigationController)
    }

    /// Loads the data on `self`.
    func loadDataIfNeeded() {
        viewModel?.loadIfNeeded(completion: { [weak self] (error) in
            switch error {
            case .some(_):
                self?.workoutStatsTableView.reloadData()
                self?.config()

                self?.percentileProgressView.setProgress(0, animated: false)
            case .none:
                self?.workoutStatsTableView.reloadData()
                self?.config()

                let percentile = ((self?.viewModel?.percentileValue).flatMap(Float.init) ?? 0) / 100
                self?.percentileProgressView.setProgress(percentile, animated: true)
            }
        })
        setLoadingStateIfNeeded()
    }

    private func setLoadingStateIfNeeded() {
        if viewModel == nil || viewModel?.didLoad == false {
            loadingView = loadingView ?? DashboardStatsLoadingView.install(in: view)
        } else {
            loadingView?.removeFromSuperview()
        }
    }

    private func config() {
        applyShadow(view: overallRankView)
        applyShadow(view: percentileView)
        applyShadow(view: workoutStatsTableView)
        applyShadow(view: viewLeaderboardButton)
        applyShadow(view: openNotStartedView)

        workoutStatsTableView.isHidden = viewModel?.numberOfScoredWorkouts == 0
        openNotStartedView.isHidden = viewModel?.numberOfScoredWorkouts != 0

        openNotStartedLabel.text = viewModel?.isOpenActive == true
            ? localization.checkBackLater
            : ((viewModel?.nextOpenYear).flatMap(localization.scoresAppearWhenOpenStarts) ?? localization.checkBackLater)

        overallRankLabel.text = localization.overallRank
        overallRankLabel.layer.anchorPoint = CGPoint(x: 1, y: 1)
        overallRankLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)

        percentileLabel.text = localization.percentile
        percentileLabel.layer.anchorPoint = CGPoint(x: 1, y: 1)
        percentileLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)

        athleteRankLabel.text = viewModel?.overallRank
        athleteRankLabel.row = viewModel?.styleableRowForPercentile.rawValue ?? 0

        if let maximumRank = viewModel?.maximumRank {
            totalAthletesLabel.text = maximumRank
            totalAthletesLabel.isHidden = false
            overallRankSlash.isHidden = false
        } else {
            totalAthletesLabel.isHidden = true
            overallRankSlash.isHidden = true
        }
        
        percentileValueLabel.setSuperscript(withText: viewModel?.percentileTextValue ?? "", withRow: .r3)
        percentileProgressView.setProgress(0, animated: false)

        workoutStats = viewModel?.workoutStats ?? []

        workoutStatsTableView.reloadData()

        setLoadingStateIfNeeded()
    }

    private func applyShadow(view: UIView) {
        let layer = view.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10
    }

}

// MARK: - UITableViewDataSource
extension DashboardStatsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutStats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(forIndexPath: indexPath) as WorkoutStatsCell
        cell.setData(viewModel: workoutStats[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

// MARK: - UITableViewDelegate
extension DashboardStatsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - CardDetailContainerDelegate
extension DashboardStatsViewController: CardDetailContainerDelegate {

    func container(_ container: CardDetailContainerViewController, changedVisibility visibility: CGFloat) {
        let percentile = ((self.viewModel?.percentileValue).flatMap(Float.init) ?? 0) / 100
        UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.percentileProgressView.setProgress(Float(visibility) * percentile,
                                                    animated: true)
        }, completion: nil)
    }

}
