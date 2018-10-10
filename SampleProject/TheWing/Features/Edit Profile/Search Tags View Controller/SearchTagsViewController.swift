//
//  SearchTagsViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SearchTagsViewController: BuildableViewController {

    // MARK: - Public Properties
    
    /// View model.
    var viewModel: SearchTagsViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView, userInputView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var userInputView: AddInputView = {
        let inputView = AddInputView()
        inputView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(viewModel.addUserInput)))
        return inputView
    }()
    
    private lazy var collectionView: TagsCollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 50)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        let collectionView = TagsCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var searchBarContainerView: UIView = {
        let containerView = UIView()
        containerView.autoSetDimension(.height, toSize: 53 + ViewConstants.navigationBarHeight)
        containerView.backgroundColor = theme.colorTheme.invertTertiary
        view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.backgroundColor = theme.colorTheme.tertiary
        borderView.autoSetDimension(.height, toSize: ViewConstants.lineSeparatorThickness)
        return borderView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        let textStyle = theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.errorPrimary)
        searchBar.setCancelButton(textStyle: textStyle)
        searchBar.setTextFieldColor(color: theme.colorTheme.emphasisQuintary.withAlphaComponent(0.05))
        searchBar.backgroundImage = theme.colorTheme.invertTertiary.image
        return searchBar
    }()

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
private extension SearchTagsViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupSearchBar()
        setupSearchBarContainerView()
        setupStackview()
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
    
    func setupStackview() {
        view.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: ViewConstants.defaultGutter)
        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: ViewConstants.defaultGutter)
        stackView.autoPinEdge(.top, to: .bottom, of: searchBarContainerView, withOffset: 14)
    }
    
    func handleDismissal() {
        searchBar.resignFirstResponder()
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - SearchTagsViewDelegate
extension SearchTagsViewController: SearchTagsViewDelegate {
    
    func setUserInput(_ text: String?) {
        userInputView.setup(theme: theme, input: text)
        userInputView.isHidden = text == nil
    }

    func refreshView() {
        collectionView.reloadData()
    }
    
    func dismissView() {
        handleDismissal()
    }
    
}

// MARK: - UICollectionViewDataSource
extension SearchTagsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(theme: theme, tag: viewModel.tags[indexPath.row], dataSource: viewModel.dataSource)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tags.count
    }
    
}

// MARK: - UICollectionViewDelegate
extension SearchTagsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tagSelected(at: indexPath)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchTagsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handleDismissal()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return viewModel.shouldChangeText(current: searchBar.text, shouldChangeTextIn: range, replacementText: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.validateSearchEntry(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        handleDismissal()
    }
    
}
