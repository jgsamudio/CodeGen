//
//  FiltersViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

final class FiltersViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: FiltersViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }

    // MARK: - Private Properties
    
    private var sectionViews = [String: TagsSectionView]()
    
    private lazy var saveButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.primaryFloatingButtonStyle)
        button.addTarget(viewModel, action: #selector(viewModel.save), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.isiPhoneXOrBigger ? 10 : 0, right: 0)
        return button
    }()
    
    private lazy var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CLEAR_ALL".localized(comment: "Clear all"),
                                     style: .plain,
                                     target: viewModel,
                                     action: #selector(viewModel.clearAll))
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.emphasisPrimary)
        button.setTitleTextStyle(with: textStyle, for: .normal)
        button.setTitleTextStyle(with: textStyle, for: .highlighted)
        button.setTitleTextStyle(with: textStyle.withColor(theme.colorTheme.emphasisQuintaryFaded), for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        scrollView.alignment = .fill
        scrollView.distribution = .fill
        scrollView.axis = .vertical
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        return scrollView
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadFilters()
    }
    
}

// MARK: - Private Functions
private extension FiltersViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBar(backgroundColor: theme.colorTheme.invertTertiary,
                                               tintColor: theme.colorTheme.emphasisPrimary,
                                               textStyle: theme.textStyleTheme.headline3)
        navigationItem.title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close_button"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancel))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        saveButton.set(height: ViewConstants.bottomButtonHeight)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: saveButton.frame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets.bottom = insets.bottom
        scrollView.defaultBottomInset = insets.bottom
    }
    
    func setupSectionViews(_ sections: FilterSections) {
        for section in sections {
            let sectionView = TagsSectionView(theme: theme, title: section.key.capitalized)
            sectionView.delegate = self
            sectionView.collectionViewMultiSelection = true
            scrollView.insertView(view: sectionView)
            sectionView.setup(tags: section.value.tagNames, dataSources: section.value.tagViewSources)
            sectionViews[section.key] = sectionView
        }
        setupSaveButton()
    }
    
    func updateSectionView(_ section: String, dataSources: PillDataSources) {
        guard let sectionView = sectionViews[section] else {
            return
        }
        
        sectionView.setup(tags: dataSources.tagNames, dataSources: dataSources.tagViewSources)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectItem(in collection: UICollectionView, at indexPath: IndexPath) {
        sectionViews.keys.forEach {
            if sectionViews[$0]?.collectionView == collection {
                viewModel.selectFilter(in: $0, at: indexPath)
                return
            }
        }
    }
    
}

// MARK: - FiltersViewDelegate
extension FiltersViewController: FiltersViewDelegate {
    
    func displaySections(_ sections: FilterSections) {
        setupSectionViews(sections)
    }
    
    func displayResultsCount(_ resultsCountInfo: String) {
        saveButton.setTitle(resultsCountInfo, for: .normal)
    }
    
    func updateSection(_ section: String, dataSources: PillDataSources) {
        updateSectionView(section, dataSources: dataSources)
    }
    
    func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func isLoading(loading: Bool) {
        saveButton.isLoading(loading: loading)
    }
    
    func displayAlert(title: String, message: String) {
        let controller = UIAlertController.singleActionAlertController(title: title, message: message)
        present(controller, animated: true, completion: nil)
    }
    
    func setRemoveAllEnabled(_ enabled: Bool) {
        clearButton.isEnabled = enabled
    }

}

// MARK: - UICollectionViewDelegate
extension FiltersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(in: collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didSelectItem(in: collectionView, at: indexPath)
    }
    
}
