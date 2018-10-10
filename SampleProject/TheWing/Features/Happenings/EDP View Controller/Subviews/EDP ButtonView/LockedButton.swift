//
//  LockedButton.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class LockedButton: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var barView: UIView = {
    
    // MARK: - Public Properties
    
        let bar = UIView()
        bar.backgroundColor = theme.colorTheme.secondary
        bar.layer.borderColor = theme.colorTheme.emphasisQuintary.cgColor
        bar.layer.borderWidth = 1.0
        return bar
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "locked_large"))
        imageView.autoSetDimensions(to: CGSize(width: 65, height: 65))
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if subview.bounds.contains(convertedPoint) {
                return subview
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
}

// MARK: - Private Functions
private extension LockedButton {
    
    func setupView() {
        addSubview(barView)
        barView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        barView.autoSetDimension(.height, toSize: ViewConstants.bottomButtonHeight)
        addSubview(imageView)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoPinEdge(.top, to: .top, of: barView, withOffset: -32.5)
    }

}
