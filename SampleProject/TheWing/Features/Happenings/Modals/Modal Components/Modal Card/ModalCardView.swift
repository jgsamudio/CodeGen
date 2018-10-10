//
//  ModalCardView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ModalCardView: BuildableView {

    // MARK: - Private Properties

    private lazy var accentView: UIView = {
    
    // MARK: - Public Properties
    
        let view = UIView()
        view.backgroundColor = theme.colorTheme.emphasisTertiary
        return view
    }()

    private var style: ModalCardStyle
    private var view: UIView

    // MARK: - Constants

    fileprivate static var gutter: CGFloat = 9

    // MARK: - Initialization

    init(view: UIView, style: ModalCardStyle, theme: Theme) {
        self.view = view
        self.style = style
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension ModalCardView {

    func setupView() {
        setupCardView()
        setupAccentView()
    }

    private func setupCardView() {
        addSubview(view)
        view.layer.borderColor = theme.colorTheme.tertiary.cgColor
        view.layer.borderWidth = 1
        view.autoPinEdge(.top, to: .top, of: self)
        positionView()
    }

    private func setupAccentView() {
        accentView.layer.borderColor = theme.colorTheme.tertiary.cgColor
        accentView.layer.borderWidth = 1

        insertSubview(accentView, belowSubview: view)
        accentView.autoMatch(.height, to: .height, of: view)
        positionAccentView()
    }
    
    private func positionView() {
        let gutter = ModalCardView.gutter * 2
        switch style {
        case .left:
            view.autoPinEdge(.leading, to: .leading, of: self, withOffset: -gutter)
            view.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -gutter)
        case .right:
            view.autoPinEdge(.leading, to: .leading, of: self, withOffset: gutter)
            view.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: gutter)
        case .center:
            view.autoPinEdge(.leading, to: .leading, of: self, withOffset: -ModalCardView.gutter)
            view.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: ModalCardView.gutter)
        }
    }
    
    private func positionAccentView() {
        let gutter = ModalCardView.gutter
        switch style {
        case .left:
            let insets = UIEdgeInsets(top: gutter, left: 0, bottom: gutter, right: gutter)
            accentView.autoPinEdgesToSuperviewEdges(with: insets)
        case .right:
            let insets = UIEdgeInsets(top: gutter, left: gutter, bottom: gutter, right: 0)
            accentView.autoPinEdgesToSuperviewEdges(with: insets)
        case .center:
            accentView.backgroundColor = theme.colorTheme.secondary
            let insets = UIEdgeInsets(top: ModalCardView.gutter, left: 0, bottom: 0, right: 0)
            accentView.autoPinEdgesToSuperviewEdges(with: insets)
        }
    }

}
