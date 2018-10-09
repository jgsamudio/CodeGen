//
//  AccountViewController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import MessageUI
import Simcoe

/// Displays Account information
final class AccountViewController: BaseViewController {

    /// View Model
    var viewModel: AccountViewModel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nameLabel: StyleableLabel!
    @IBOutlet private weak var emailLabel: StyleableLabel!
    private let localization = AccountLocalization()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = AccountTableViewCell.heightEstimate
        tableView.tableFooterView = UIView(frame: .zero)
        nameLabel.text = viewModel.fullname
        emailLabel.text = viewModel.email
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
    }

    private func presentEmailViewController() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients([localization.emailRecipient])
            mailComposeViewController.setSubject(localization.emailSubject)
            mailComposeViewController.setMessageBody(localization.emailMessageBody, isHTML: false)
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            BannerManager.showBanner(text: localization.emailError)
        }
    }

    private func trackTapEvent(_ cellOption: AccountCellOption) {
        var event: AnalyticsKey.Event!
        switch cellOption {
        case .help:
            event = .help
        case .ruleBook:
            event = .ruleBook
        case .drugPolicy:
            event = .drugPolicy
        case .contactUs:
            event = .contactUs
        case .login:
            event = .login
        case .logout:
            event = .logout
        case .faq:
            event = .logout
        }
        Simcoe.track(event: event,
                     withAdditionalProperties: [:], on: .settings)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
        cell.labelContent = viewModel.dataSource[indexPath.row].localize()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellIndexPath = viewModel.dataSource[indexPath.row]
        trackTapEvent(cellIndexPath)
        switch cellIndexPath {
        case .help, .ruleBook, .drugPolicy:
            guard let url = cellIndexPath.url() else { return }
            let safariViewController = SFSafariBuilder(url: url).build()
            safariViewController.modalPresentationStyle = .overFullScreen
            present(safariViewController, animated: true)
        case .contactUs:
            presentEmailViewController()
        case .faq:
            guard let url = cellIndexPath.url() else { return }
            let safariViewController = SFSafariBuilder(url: url).build()
            safariViewController.modalPresentationStyle = .overFullScreen
            present(safariViewController, animated: true)
        case .login, .logout:
            viewModel.logout()
            animateToHomeScreen()
        }
    }

}

// MARK: - MFMailComposeViewControllerDelegate
extension AccountViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
