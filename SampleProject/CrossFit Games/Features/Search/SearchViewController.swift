//
//  SearchViewController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

final class SearchViewController: BaseViewController {

    // MARK: - Public Properties
    
    var viewModel: SearchViewModel!

    // MARK: - Private Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBarView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    private let offsetTranslation = CGAffineTransform(translationX: 0, y: -50)
    private let localization = LeaderboardLocalization()
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var zeroResultsLabel: StyleableLabel!

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarView.transform = offsetTranslation
        searchBarView.alpha = 0
        filterLabel.alpha = 0
        tableView.registerNibForCells([SearchTableViewCell.self])
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = SearchTableViewCell.heightEstimate
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.enableKeyboardOffset()
        zeroResultsLabel.text = localization.searchNoResults
        searchTextField.attributedPlaceholder = NSAttributedString(string: localization.searchPlaceholder,
                                                                   attributes: StyleGuide.shared.style(row: .r2, column: .c5, weight: .w2))
        searchTextField.typingAttributes = StyleGuide.shared.styleRaw(row: .r2, column: .c4, weight: .w2)
        filterLabel.attributedText = NSAttributedString(string: viewModel.filterTitle,
                                                        attributes: StyleGuide.shared.style(row: .r2, column: .c5, weight: .w2))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        searchTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.20, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.searchBarView.alpha = 1
            self?.searchBarView.transform = .identity
            }, completion: nil)
        UIView.animate(withDuration: 0.40, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.filterLabel.alpha = 1
            }, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    @IBAction private func cancelButtonTapped(_ sender: StyleableButton) {
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.40, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.searchBarView.alpha = 0
            self?.searchBarView.transform = self?.offsetTranslation ?? .identity
            self?.view.alpha = 0
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
                Simcoe.track(event: .leaderboardSearchCancelled,
                             withAdditionalProperties: [:],
                             on: .search)
        })
    }

    private func triggerSearch(text: String?) {
        viewModel.search(text: text) { [weak self] (leaderboardSearchResults, error) in
            if error != nil {
                BannerManager.showError()
            } else if let wself = self, let text = text {
                wself.viewModel.leaderboardSearchResults = leaderboardSearchResults ?? []
                wself.tableView.reloadData()
                let shouldShow = !text.isEmpty && wself.viewModel.leaderboardSearchResults.isEmpty
                let duration = shouldShow ? 0.3 : 0
                UIView.animate(withDuration: duration, animations: {
                    wself.zeroResultsLabel.alpha = shouldShow ? 1 : 0
                })
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leaderboardSearchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
        let searchResult = viewModel.leaderboardSearchResults[indexPath.row]
        cell.setup(top: searchResult.name, bottom: searchResult.affiliate)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tabBarController = presentingViewController as? UITabBarController else {
            return
        }
        startActivityIndicator()
        viewModel.navigateToLeaderboard(switchingTabIn: tabBarController, for: indexPath) { [weak self] in
            if let athleteModel = self?.viewModel.leaderboardSearchResults[indexPath.row] {
                Simcoe.track(event: .leaderboardSearchCompleted,
                             withAdditionalProperties: [.athleteName: athleteModel.name,
                                                        .athleteId: athleteModel.identifier],
                             on: .search)
            }

            self?.stopActivityIndicator()
            self?.dismiss(animated: true)
        }
    }

}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        triggerSearch(text: textAfterUpdate)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        triggerSearch(text: textField.text)
        return true
    }

}
