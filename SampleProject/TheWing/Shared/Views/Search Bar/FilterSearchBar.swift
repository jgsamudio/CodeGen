//
//  FilterSearchBar.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FilterSearchBar: OverflowingBuildableView {

    // MARK: - Public Properties

    weak var delegate: FilterSearchDelegate?
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            searchTextField.isUserInteractionEnabled = isUserInteractionEnabled
            filterButton.isUserInteractionEnabled = isUserInteractionEnabled
            cancelButton.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    /// Flag to indiciate if the search bar is in focus.
    var isSearchBarFocused = false
    
    // MARK: - Private Properties

    private var searchTextField = UITextField()
    private var searchImage = UIImageView(image: #imageLiteral(resourceName: "search"))

    private lazy var underline: UIView = {
        return UIView.dividerView(height: 1, color: colorTheme.tertiary)
    }()

    private lazy var filterButton: FilterButton = {
        let filterButton = FilterButton(theme: theme)
        filterButton.setFilterCount(0)
        filterButton.addTarget(self, action: #selector(filterButtonSelected), for: .touchUpInside)
        return filterButton
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let textStyle = textStyleTheme.bodyNormal.withColor(colorTheme.errorPrimary)
        button.setTitleText("CANCEL_TITLE".localized(comment: "Cancel"), using: textStyle)
        button.alpha = 0
        button.addTarget(self, action: #selector(cancelButtonSelected), for: .touchUpInside)
        return button
    }()

    private var heightConstraint: NSLayoutConstraint?
    private var textFieldTrailingConstraint: NSLayoutConstraint?
    private var underlineTrailingConstraint: NSLayoutConstraint?

    // MARK: - Constants

    private static let imageSize = CGSize(width: 14, height: 14)
    private static let clearButtonSize = CGSize(width: 15, height: 15)
    private static let defaultGutter: CGFloat = 24
    private static let unFocusedHeight: CGFloat = 43
    private static let focusedHeight: CGFloat = 62
    private static let unFocusedTrailingGutter: CGFloat = -143
    private static let focusedTrailingGutter: CGFloat = -83

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets the count on the filters button.
    ///
    /// - Parameter count: Count of filters selected.
    func setFilterCount(_ count: Int) {
        filterButton.setFilterCount(count)
    }
    
    /// Resets search text field.
    ///
    /// - Parameter hasSearchText: Flag to indicate if search text was previous entered.
    func resetSearchField(hasSearchText: Bool) {
        removeInputs()
        if hasSearchText {
          searchTextField.becomeFirstResponder()
        }
    }

}

// MARK: - Private Functions
private extension FilterSearchBar {

    func setupView() {
        heightConstraint = autoSetDimension(.height, toSize: FilterSearchBar.unFocusedHeight)
        setupImage()
        setupSearchTextField()
        setupUnderlineView()
        setupFilterButton()
        setupCancelButton()
    }

    func setupSearchTextField() {
        addSubview(searchTextField)
        searchTextField.autoSetDimension(.height, toSize: 22)	
        searchTextField.autoPinEdge(.leading, to: .trailing, of: searchImage, withOffset: 7)

        textFieldTrailingConstraint = searchTextField.autoPinEdge(.trailing,
                                                                  to: .trailing,
                                                                  of: self,
                                                                  withOffset: FilterSearchBar.unFocusedTrailingGutter)

        searchTextField.autoPinEdge(.top, to: .top, of: self)
        searchImage.autoAlignAxis(.horizontal, toSameAxisOf: searchTextField)

        searchTextField.font = textStyleTheme.bodyNormal.font
        searchTextField.delegate = self
        searchTextField.placeholder = "SEARCH".localized(comment: "Search")
        searchTextField.returnKeyType = .search
        setupRightViewIconToSearchTextField()
    }
    
    func setupRightViewIconToSearchTextField() {
        let button = UIButton(type: .custom)
        button.autoSetDimensions(to: FilterSearchBar.clearButtonSize)
        button.setImage(#imageLiteral(resourceName: "clear_button"), for: .normal)
        button.addTarget(self, action: #selector(removeInputs), for: .touchUpInside)
        searchTextField.rightView = button
        searchTextField.rightViewMode = .always
        searchTextField.rightView?.isHidden = true
    }

    func setupImage() {
        addSubview(searchImage)
        searchImage.autoSetDimensions(to: FilterSearchBar.imageSize)
        searchImage.autoPinEdge(.leading, to: .leading, of: self, withOffset: FilterSearchBar.defaultGutter)
    }

    func setupUnderlineView() {
        addSubview(underline)
        underline.autoPinEdge(.leading, to: .leading, of: self, withOffset: FilterSearchBar.defaultGutter)
        underline.autoPinEdge(.top, to: .bottom, of: searchTextField, withOffset: 3)

        underlineTrailingConstraint = underline.autoPinEdge(.trailing,
                                                            to: .trailing,
                                                            of: self,
                                                            withOffset: FilterSearchBar.unFocusedTrailingGutter)
    }

    func updateUnderlineColor(isActive: Bool) {
        underline.backgroundColor = isActive ? colorTheme.emphasisQuintary : colorTheme.tertiary
    }

    func setupFilterButton() {
        addSubview(filterButton)
        filterButton.layoutIfNeeded()
        filterButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: -filterButton.frame.height / 2)
        filterButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: ViewConstants.headerGutter)
    }

    func setupCancelButton() {
        addSubview(cancelButton)
        cancelButton.autoSetDimensions(to: CGSize(width: 50, height: 44))
        cancelButton.autoAlignAxis(.horizontal, toSameAxisOf: searchTextField)
        cancelButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -FilterSearchBar.defaultGutter)
    }

    @objc func filterButtonSelected() {
        delegate?.filterButtonSelected()
    }

    @objc func cancelButtonSelected() {
        removeInputs()
        searchBar(focused: false)
        searchTextField.resignFirstResponder()
        delegate?.cancelSearch()
    }
    
    func searchBar(focused: Bool) {
        heightConstraint?.constant = focused ? FilterSearchBar.focusedHeight : FilterSearchBar.unFocusedHeight
        
        let trailingConstraint = focused ? FilterSearchBar.focusedTrailingGutter : FilterSearchBar.unFocusedTrailingGutter
        textFieldTrailingConstraint?.constant = trailingConstraint
        underlineTrailingConstraint?.constant = trailingConstraint
        
        isSearchBarFocused = focused
        delegate?.animateConstraints()
        showCancelButton(focused)
    }
    
    func showCancelButton(_ show: Bool) {
        UIView.animate(withDuration: AnimationConstants.defaultDuration) {
            self.cancelButton.alpha = show ? 1 : 0
        }
    }
    
    @objc func removeInputs() {
        searchTextField.text = ""
    }
    
}

// MARK: - UITextFieldDelegate
extension FilterSearchBar: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.rightView?.isHidden = false
        updateUnderlineColor(isActive: true)
        searchBar(focused: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.rightView?.isHidden = true
        updateUnderlineColor(isActive: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        delegate?.displaySearchResult(with: textField.text)
        return true
    }

}
