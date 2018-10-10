//
//  OnboardingTagsEditorViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

final class OnboardingTagsEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: OnboardingTagsEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override var progressStep: OnboardingProgressStep? {
        return viewModel.progressStep
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel(text: viewModel.title.uppercased(),
                                          using: theme.textStyleTheme.displayHuge.withColor(theme.colorTheme.primary))
    
    private lazy var subtitleLabel = UILabel(text: viewModel.description, using: theme.textStyleTheme.bodyNormal)
    
    private lazy var helperLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        let textStyle = theme.textStyleTheme.captionBig.withColor(theme.colorTheme.primary).withAlignment(.center)
        label.setMarkdownText("**\(OnboardingLocalization.tagsHelper.uppercased())**", using: textStyle)
        return label
    }()
    
    private lazy var scrollView = PilasScrollView(alignment: .fill, distribution: .fill, axis: .vertical)
    
    private lazy var buttonsView: OnboardingButtonsView = {
        let subview = OnboardingButtonsView(theme: theme, delegate: self, gutter: ViewConstants.defaultGutter)
        subview.showNextButton(show: true)
        return subview
    }()
    
    private lazy var searchBarView: SearchBar = {
        let subview = SearchBar(theme: theme)
        subview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(search)))
        subview.setPlaceholder(text: viewModel.searchTitle)
        subview.autoSetDimension(.height, toSize: 36)
        return subview
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
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.colorTheme.invertTertiary
        let subview = UIStackView(arrangedSubviews: [], axis: .vertical, distribution: .fill, alignment: .fill)
        subview.addArrangedSubview(titleLabel)
        subview.addArrangedSubview(UIView.dividerView(height: 4))
        subview.addArrangedSubview(subtitleLabel)
        view.addSubview(subview)
        subview.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .bottom)
        subview.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
        return view
    }()
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        let subview = UIStackView(arrangedSubviews: [searchBarView, helperLabel, collectionView],
                                  axis: .vertical,
                                  distribution: .fill,
                                  alignment: .fill,
                                  spacing: 24)
        subview.addArrangedSubview(UIView.dividerView(height: 104))
        view.addSubview(subview)
        subview.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        subview.autoPinEdge(toSuperviewEdge: .top, withInset: ViewConstants.defaultGutter)
        return view
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.backgroundColor = bodyBackgroundColor()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        scrollView.autoPinEdge(.top, to: .top, of: view, withOffset: 85)
        scrollView.insertView(view: headerView)
        scrollView.insertView(view: bodyView)
        viewModel.loadExampleTags()
        
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
    }
    
}

// MARK: - Private Functions
private extension OnboardingTagsEditorViewController {
    
    @objc func search() {
        var viewController: UIViewController
        switch viewModel.type {
        case .asks:
            viewController = builder.searchTagsViewController(type: .asks((isSelectable: false, isRemovable: false)),
                                                              searchDelegate: viewModel)
        case .offers:
            viewController = builder.searchTagsViewController(type: .offers((isSelectable: false, isRemovable: false)),
                                                              searchDelegate: viewModel)
        case .interests:
            viewController = builder.searchTagsViewController(type: .interests((isSelectable: false, isRemovable: false)),
                                                              searchDelegate: viewModel)
        }
        present(viewController, animated: true, completion: nil)
    }
    
    func bodyBackgroundColor() -> UIColor {
        switch viewModel.type {
        case .asks:
            return theme.colorTheme.invertSecondary
        case .offers:
            return theme.colorTheme.invertPrimary
        case .interests:
            return theme.colorTheme.invertTertiaryMuted
        }
    }
    
    func dataSource() -> TagViewDataSource {
        switch viewModel.type {
        case .asks:
            return OnboardingProfileTagType.asks(selected: false)
        case .offers:
            return OnboardingProfileTagType.offers(selected: false)
        case .interests:
            return OnboardingProfileTagType.interests(selected: false)
        }
    }
    
    func selectedDataSource() -> TagViewDataSource {
        switch viewModel.type {
        case .asks:
            return OnboardingProfileTagType.asks(selected: true)
        case .offers:
            return OnboardingProfileTagType.offers(selected: true)
        case .interests:
            return OnboardingProfileTagType.interests(selected: true)
        }
    }
    
}

// MARK: - OnboardingTagsEditorViewDelegate
extension OnboardingTagsEditorViewController: OnboardingTagsEditorViewDelegate {
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func proceed() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }
    
    func refreshCollection() {
        collectionView.reloadData()
    }
    
    func showError(_ error: Error?) {
        presentAlertController(withNetworkError: error)
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingTagsEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.next()
    }
    
}

// MARK: - UICollectionViewDataSource
extension OnboardingTagsEditorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let tagSource = viewModel.isSelected(at: indexPath.row) ? selectedDataSource() : dataSource()
        cell.setupDarkTheme(theme: theme, tag: viewModel.tags[indexPath.row], dataSource: tagSource)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tags.count
    }
    
}

// MARK: - UICollectionViewDelegate
extension OnboardingTagsEditorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectTag(at: indexPath.row)
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingTagsEditorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonsView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}
