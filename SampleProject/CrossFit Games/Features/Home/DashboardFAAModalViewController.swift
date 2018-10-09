//
//  DashboardFAAModalViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Simcoe
import UIKit

/// The Modal which appears when taps on the following athlete,
/// which contains the following athlete's workout scores and the rank details
final class DashboardFAAModalViewController: UIViewController {

    @IBOutlet private var containerViewVerticallyCenterConstraint: NSLayoutConstraint!
    @IBOutlet private var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: FixedSizeTableView!
    @IBOutlet private weak var nameLabel: StyleableLabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var rankLabel: StyleableLabel!
    @IBOutlet private weak var divisionLabel: StyleableLabel!
    @IBOutlet private weak var containerView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel: DashboardFollowAnAthleteViewModel!

    private let localization = DashboardLocalization()
    private let rowHeight: CGFloat = 25
    private let imageSize: CGFloat = 49
    private let thresholdRecordCount = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = viewModel {
            nameLabel.text = viewModel.name

            profileImageView.download(imageURL: viewModel.imageUrl)
            profileImageView.layer.cornerRadius = imageSize / 2
            profileImageView.layer.masksToBounds = true

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
            tapGesture.delegate = self
            view.addGestureRecognizer(tapGesture)

            divisionLabel.text = localization.faaDivision(division: viewModel.division ?? "")

            let rank = Int(viewModel.rank ?? "")?.format()
            let totalAthleteCount = viewModel.totalAthleteCount.format()
            rankLabel.text = "\(rank ?? "")/\(totalAthleteCount ?? "")"

            if viewModel.formattedWorkouts.count > thresholdRecordCount {
                containerViewTopConstraint.isActive = true
                containerViewTopConstraint.constant = UIScreen.main.bounds.height * 0.1
                containerViewVerticallyCenterConstraint.isActive = false
            } else {
                containerViewTopConstraint.isActive = false
                containerViewVerticallyCenterConstraint.isActive = true
            }
            tableView.reloadData()
        }
        showAnimate()
    }

    @IBAction private func didTapClose(_ sender: UIButton) {
        dismissView()
    }

    @IBAction func didTapUnfollowAthlete(_ sender: StyleableButton) {
        Simcoe.track(event: .followAthleteRemove,
                     withAdditionalProperties: [:], on: .followAthlete)
        viewModel?.unfollowAthlete()
        /// Notifies, so that the relevant updates could be made in the dashboard and the leaderboard
        NotificationCenter.default.post(name: NotificationName.followingAthleteDidUpdate.name,
                                        object: nil,
                                        userInfo: [NotificationKey.isFromDashBoard: true])
        dismissView()
    }

    private func showAnimate() {
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.containerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                        self?.containerView.alpha = 0
        },
                       completion: { [weak self] _ in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0,
                                       usingSpringWithDamping: 0.65,
                                       initialSpringVelocity: 4.0,
                                       options: .allowUserInteraction,
                                       animations: {
                                        self?.containerView.transform = .identity
                                        self?.containerView.alpha = 1
                        },
                                       completion: nil)

        })
    }

    /// Removes the modal view
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.view.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: { [weak self] finished in
                if finished {
                    self?.dismiss(animated: true, completion: nil)
                }
        })
    }

}

// MARK: - UIGestureRecognizerDelegate
extension DashboardFAAModalViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if containerView.bounds.contains(touch.location(in: containerView)) {
            return false
        }
        return true
    }

}

// MARK: - UITableViewDataSource
extension DashboardFAAModalViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.formattedWorkouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formattedWorkout = viewModel.formattedWorkouts[indexPath.row]
        let cell: DashboardFAAWorkoutCell = tableView.dequeueCell(forIndexPath: indexPath)
        if let workout = formattedWorkout.first,
            let score = workout.value {
            cell.setData(with: score, title: workout.key)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

}

// MARK: - UITableViewDelegate
extension DashboardFAAModalViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: DashboardFAAWorkoutHeaderCell = tableView.dequeueCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowHeight
    }

}
