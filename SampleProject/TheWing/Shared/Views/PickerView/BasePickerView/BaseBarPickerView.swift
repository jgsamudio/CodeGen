//
//  BaseBarPickerView.swift
//  TheWing
//
//  Created by Luna An on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

class BaseBarPickerView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var baseDelegate: BaseBarPickerViewDelegate?
    
    /// Title of the picker view bar.
    var barTitle: String = "" {
        didSet {
            let color = theme.colorTheme.emphasisQuintary
            let textStyle = theme.textStyleTheme.headline4.withColor(color)
            barTitleLabel.setText(barTitle, using: textStyle)
        }
    }
    
    /// Property to show and hide the loading indicator.
    var isLoading: Bool = false {
        didSet {
            isPickerLoading(isLoading)
        }
    }
    
    // MARK: - Private Properties
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - Private Properties
    
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.addSubview(barTitleLabel)
        view.addSubview(doneButton)
        view.backgroundColor = theme.colorTheme.invertPrimary
        barTitleLabel.autoCenterInSuperview()
        doneButton.autoAlignAxis(.horizontal, toSameAxisOf: view)
        doneButton.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -18)
        doneButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        let color = theme.colorTheme.emphasisPrimary
        let doneText = "DONE".localized(comment: "Done")
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(color).withStrongFont().withMinLineHeight(0)
        button.setTitleText(doneText, using: textStyle)
        button.addTarget(self, action: #selector(doneButtonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: LoadingIndicator = {
        let loadingIndicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        addSubview(loadingIndicator)
        loadingIndicator.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        loadingIndicator.autoPinEdge(.top, to: .bottom, of: topBarView)
        return loadingIndicator
    }()
    
    private var barTitleLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension BaseBarPickerView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.invertTertiary
        autoSetDimension(.height, toSize: 260 + (UIApplication.shared.safeAreaInsets().bottom))
        setupPickerTopBar()
        setupPicker()
    }
    
    func setupPickerTopBar() {
        addSubview(topBarView)
        topBarView.autoSetDimension(.height, toSize: 44)
        topBarView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    func setupPicker() {
        addSubview(pickerView)
        pickerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        pickerView.autoPinEdge(.top, to: .bottom, of: topBarView)
    }
    
    @objc func doneButtonSelected() {
        baseDelegate?.didSelectDone()
    }
    
    func isPickerLoading(_ loading: Bool) {
        UIView.animate(withDuration: AnimationConstants.loadingIndicatorDuration, animations: {
            self.pickerView.alpha = loading ? 0 : 1
        })
        loadingIndicator.isLoading(loading: loading)
    }
    
}
