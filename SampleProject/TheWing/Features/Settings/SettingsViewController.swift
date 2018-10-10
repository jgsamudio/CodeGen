//
//  SettingsViewController.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import StoreKit

final class SettingsViewController: BuildableViewController {
    
    // MARK: - Public Properties

    var viewModel: SettingsViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Delegate for account status.
    weak var accountDelegate: UserAccountDelegate?
    
    // MARK: - Private Properties
    
    private lazy var navigationView = NavigationView(theme: theme, backButtonImage: #imageLiteral(resourceName: "black_back_button"))
    
    private lazy var tableView: UITableView = { 
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.registerCell(cellClass: SettingsItemTableViewCell.self)
        tableView.registerHeaderFooterView(SettingsSectionHeader.self)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()
    
    private lazy var versionNumberLabel: UILabel = {
        return UILabel(text: Bundle.main.formattedReleaseVersionNumber,
                       using: textStyleTheme.captionNormal,
                       with: colorTheme.tertiary)
    }()

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
}

// MARK: - Private Functions
private extension SettingsViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.invertPrimary
        setupNavigationView()
        setupVersionLabel()
        setupTableView()
    }

    private func setupNavigationView() {
        navigationView.delegate = self
        navigationView.set(title: SettingsLocalization.settingsTitle)
        view.addSubview(navigationView)
        navigationView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    private func setupVersionLabel() {
        view.addSubview(versionNumberLabel)
        versionNumberLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        versionNumberLabel.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -33)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.autoPinEdge(.top, to: .bottom, of: navigationView)
        tableView.autoPinEdge(.leading, to: .leading, of: view)
        tableView.autoPinEdge(.trailing, to: .trailing, of: view)
        tableView.autoPinEdge(.bottom, to: .top, of: versionNumberLabel)
    }

}

// MARK: - SettingsViewDelegate
extension SettingsViewController: SettingsViewDelegate {
    
    func toggleHappeningsRemindersNotification(_ isOn: Bool) {
        viewModel.updateUserDefaults(switchType: .events, isOn: isOn)
        viewModel.identifyUserTraits(from: .events)
    }
    
    func toggleAnnouncementsNotification(_ isOn: Bool) {
        viewModel.updateUserDefaults(switchType: .announcements, isOn: isOn)
        viewModel.identifyUserTraits(from: .announcements)
    }
    
    func rateUsAtTheAppStoreSelected() {
        if Reachability.shared.connected {
            SKStoreReviewController.requestReview()
        } else {
            present(UIAlertController(withNetworkError: nil), animated: true)
        }
    }
    
    func contactUsSelected(email: String) {
        presentEmailActionSheet(address: email)
    }

    func logOutSelected() {
        navigationController?.popToRootViewController(animated: false)
        accountDelegate?.userLoggedOut()
    }

}

// MARK: - NavigationViewDelegate
extension SettingsViewController: NavigationViewDelegate {
    
    func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsSection.allSections[section].associatedMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let menuItem = SettingsSection.allSections[indexPath.section].associatedMenuItems[indexPath.row]
        cell.setup(theme: theme,
                   title: menuItem.title,
                   hasSwitch: menuItem.hasSwitch,
                   switchType: menuItem.switchType,
                   isOn: menuItem.isOn,
                   color: menuItem.isLogOut ? colorTheme.errorPrimary : nil)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case SettingsSection.notifications.rawValue:
            return 54
        default:
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SettingsSectionHeader = tableView.dequeueReusableHeaderFooterView()
        header.setup(theme: theme, title: section == 0 ? SettingsLocalization.notificationsSectionTitle : "")
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = SettingsSection.allSections[indexPath.section].associatedMenuItems[indexPath.row]
        viewModel.menuItemSelected(settingsItem: menuItem)
    }
    
}

// MARK: - SettingsItemViewDelegate
extension SettingsViewController: SettingsItemViewDelegate {
    
    func toggleNotifications(switchType: SettingsSwitchType?, isOn: Bool) {
        guard let type = switchType else {
            return
        }
        
        switch type {
        case .announcements:
            viewModel.menuItemSelected(settingsItem: .announcements(isOn))
        case .events:
            viewModel.menuItemSelected(settingsItem: .eventReminders(isOn))
        }
    }
    
}
