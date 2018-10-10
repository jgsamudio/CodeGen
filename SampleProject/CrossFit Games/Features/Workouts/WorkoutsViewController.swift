//
//  WorkoutsViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

final class WorkoutsViewController: BaseViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!

    // MARK: - Public Properties
    
    var viewModel: WorkoutsViewModel!
    private let generalLocalization = GeneralLocalization()
    private let localization = WorkoutsLocalization()
    private var liveWorkouts: [WorkoutViewModel] = []
    private var completedWorkouts: [WorkoutViewModel] = []
    private var competitionYears: [String: WorkoutCompetition] = [:]
    private var scrollObserver: AnyObject?
    private var isRefreshing: Bool = false

    private var liveSection: Int? {
        if !liveWorkouts.isEmpty {
            return 0
        } else {
            return nil
        }
    }

    private var completedSection: Int? {
        if !liveWorkouts.isEmpty && !completedWorkouts.isEmpty {
            return 1
        } else if !completedWorkouts.isEmpty {
            return 0
        } else {
            return nil
        }
    }

    private var shrinkableTopView: ScrollViewShrinkableTopView?

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        resetCompetitions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutFooterView()
    }

    private func config() {
        #if ALPHA || BETA || DEBUG
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(resetCompetitions),
                                                   name: NotificationName.yoshiDatePickerUpdated.name,
                                                   object: nil)
        #endif

        NotificationCenter.default.addObserver(self, selector: #selector(observeRefresh), name: NotificationName.refreshData.name, object: nil)
        
        // Ensures the top padding is removed in the initial loading
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerNibForHeaderFooter([WorkoutSectionHeaderView.self, WorkoutSectionFooterView.self])

        tableView.estimatedRowHeight = WorkoutCell.rowHeight

        viewModel.select(competition: CompetitionPhase.open.localize(localization: localization))

        shrinkableTopView = UINib(nibName: String(describing: ScrollViewShrinkableTopView.self), bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? ScrollViewShrinkableTopView
        shrinkableTopView?.attach(to: tableView, scrollViewTopConstraint: tableViewTopConstraint)
        shrinkableTopView?.buttonTitle = generalLocalization.filter
        shrinkableTopView?.callback = { [weak self] in
            self?.didTapFilter()
        }
        tableView.refreshControl = IOS11CompatibleRefreshControl()

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

    }

    private func refreshWorkouts() {
        guard let containerVC = self.parent?.parent as? WorkoutContainerViewController else {
            return
        }
        containerVC.displayLoaderVC()
        isRefreshing = true
        resetCompetitions()
    }

    @objc private func observeRefresh() {
        resetCompetitions()
    }

    @objc private func resetCompetitions(isRetrying: Bool = false,
                                         completion: @escaping (Error?) -> Void = { _ in }) {
        guard let competitionPhase = viewModel.selectedCompetition else {
            return
        }
        viewModel.getWorkoutCompetitons(byCompetitionPhase: competitionPhase, completion: {[weak self] (competitions, error) in
            if let error = error {
                if isRetrying {
                    completion(error)
                } else {
                    switch error {
                    case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                        KillSwitchManager.hideWindow()
                        KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                    case APIError.inactive(title: let title, message: let message):
                        FullscreenErrorView.presentWindow(title: title, message: message, onTap: { [weak self] retry in
                            self?.resetCompetitions(isRetrying: true, completion: retry)
                        })
                    default:
                        KillSwitchManager.hideWindow()
                        guard let view = self?.view else {
                            return
                        }
                        FullscreenErrorView.cover(view, onTap: { retry in
                            self?.resetCompetitions(isRetrying: true, completion: retry)
                        })
                    }
                }
            } else {
                KillSwitchManager.hideWindow()

                self?.competitionYears = competitions ?? [:]

                let maxYear = competitions?.keys.sorted(by: { (year1, year2) in
                    return Int(year1) ?? 0 > Int(year2) ?? 0
                }).first ?? ""
                guard let competition = competitions?[maxYear] else {
                    return
                }
                self?.filtertWorkouts(byIdentifier: competition.identifier)
                self?.viewModel.select(year: competitions?.first?.key ?? "")
                self?.setFilterText()
            }

        })
    }

    @objc private func filtertWorkouts(byIdentifier identifier: String,
                                       isRetrying: Bool = false,
                                       completion: @escaping (Error?) -> Void = { _ in }) {
        viewModel.getWorkouts(byIdentifier: identifier, completion: { [weak self] (workouts, error) in
            if let error = error {
                if isRetrying {
                    completion(error)
                } else {
                    switch error {
                    case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                        KillSwitchManager.hideWindow()
                        KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                    case APIError.inactive(title: let title, message: let message):
                        FullscreenErrorView.presentWindow(title: title, message: message, onTap: { [weak self] retry in
                            self?.filtertWorkouts(byIdentifier: identifier, isRetrying: true, completion: retry)
                        })
                    default:
                        KillSwitchManager.hideWindow()
                        guard let view = self?.view else {
                            return
                        }
                        FullscreenErrorView.cover(view, onTap: { retry in
                            self?.resetCompetitions(isRetrying: true, completion: retry)
                        })
                    }
                }
            } else {
                KillSwitchManager.hideWindow()
                guard let workouts = workouts else {
                    return
                }
                self?.completedWorkouts = workouts.filter { $0.isCompleted }
                self?.liveWorkouts = workouts.filter { $0.isLiveWorkout }
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
                if self?.isRefreshing == true, #available(iOS 11.0, *) {
                    self?.navigationController?.navigationBar.prefersLargeTitles = false
                } else if self?.isRefreshing == false, #available(iOS 11.0, *) {
                    self?.navigationController?.navigationBar.prefersLargeTitles = true
                }

                self?.isRefreshing = false
                guard let containerVC = self?.parent?.parent as? WorkoutContainerViewController else {
                    return
                }
                containerVC.displayWorkouts()
            }
        })
    }

    private func setFilterText() {
        let contentString = [viewModel.selectedCompetition?.rawValue, viewModel.selectedYear].flatMap { $0 }.joined(separator: " ")
        shrinkableTopView?.content = contentString
        shrinkableTopView?.collapsedContent = contentString
    }

    private func submitScore(from button: StyleableButton?) {
        button?.showLoading(withColor: .white)
        viewModel.showSubmitScore(in: self, completion: { [weak self] error in
            button?.hideLoading()

            if error != nil {
                BannerManager.showBanner(text: GeneralLocalization().errorMessage,
                                         onTap: { self?.submitScore(from: button) })
            }
        })
    }

}

// MARK: - Tableview datasource
// MARK: - UITableViewDataSource
extension WorkoutsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == liveSection
            ? liveWorkouts.count
            : section == completedSection
            ? completedWorkouts.count
            : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutCell = tableView.dequeueCell(forIndexPath: indexPath)
        if indexPath.section == liveSection {
            cell.setData(workout: liveWorkouts[indexPath.row])
        } else if indexPath.section == completedSection {
            cell.setData(workout: completedWorkouts[indexPath.row])
        }
        cell.submitScoreCallback = { [weak self] in
            self?.submitScore(from: cell.submitScoreButton)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return [liveSection, completedSection].flatMap { $0 }.count
    }

}

// MARK: - Tableview delegate
// MARK: - UITableViewDelegate
extension WorkoutsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == liveSection && liveWorkouts.isEmpty {
            return 0
        } else if section == completedSection && completedWorkouts.isEmpty {
            return 0
        } else {
            return WorkoutSectionHeaderView.viewHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WorkoutSectionFooterView.viewHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedWorkout: WorkoutViewModel!
        if indexPath.section == liveSection {
            selectedWorkout = liveWorkouts[indexPath.row]
        } else if indexPath.section == completedSection {
            selectedWorkout = completedWorkouts[indexPath.row]
        }

        Simcoe.track(event: .workoutDetails,
                     withAdditionalProperties: [.id: selectedWorkout.workout.id,
                                                .workout: selectedWorkout.title ?? ""],
                     on: .workoutPages)

        let workoutDetailsViewController = WorkoutDetailsBuilder(viewModel: selectedWorkout).build()
        workoutDetailsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(workoutDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooterView(forSection: section) as WorkoutSectionHeaderView?
        header?.isLive = section == liveSection
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueHeaderFooterView(forSection: section) as WorkoutSectionFooterView?
        return footer
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *), self.navigationController?.navigationBar.prefersLargeTitles == false {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        shrinkableTopView?.scrollViewDidScroll(tableView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        shrinkableTopView?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.refreshControl?.isRefreshing == true {
            refreshWorkouts()
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if #available(iOS 11.0, *) {
            scrollObserver = tableView.observe(\.contentOffset,
                                               options: NSKeyValueObservingOptions.new,
                                               changeHandler: { [weak self] (sv, change) in
                                                if change.newValue?.y == 0 {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                        sv.setContentOffset(.zero, animated: true)
                                                    })
                                                    self?.scrollObserver = nil
                                                }
            })
        }
        return true
    }

}

// MARK: - Workouts Table Header View Delegate
extension WorkoutsViewController {

    func didTapFilter() {
        let rows = competitionYears.keys.map { (value) -> PickerViewRow in
            return PickerViewRow(displayValue: value, callback: { [weak self] in
                self?.viewModel.select(year: value)
                let identifier = self?.competitionYears[value]?.identifier ?? ""
                self?.filtertWorkouts(byIdentifier: identifier)
                self?.setFilterText()
                Simcoe.track(event: .workoutsFilter,
                             withAdditionalProperties: [.year: value],
                             on: .workoutPages)
            })
        }

        let component = PickerViewComponent(displayValues: rows, selectedRow: viewModel.selectedYear.flatMap({ (value) -> PickerViewRow? in
            return PickerViewRow(displayValue: value, callback: { [weak self] in
                self?.viewModel.select(year: value)
                self?.setFilterText()
            })
        }))

        let builder = PickerViewBuilder(pickerViewModel: PickerViewModel(components: [component]))
        present(builder.build(), animated: true, completion: nil)
    }

}

// MARK: - SponsorViewDelegate
extension WorkoutsViewController: SponsorViewDelegate {

    func tappedLogo(url: URL) {
        let safariViewController = SFSafariBuilder(url: url).build()
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true)
    }

}

// MARK: - TabBarTappable
extension WorkoutsViewController: TabBarTappable {

    func handleTabBarTap() {
        tableView.setContentOffset(.zero, animated: true)
    }

}
