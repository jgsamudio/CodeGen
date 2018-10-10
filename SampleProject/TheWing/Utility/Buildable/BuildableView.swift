//
//  BuildableView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Base class for building themed views.
class BuildableView: UIView {

    // MARK: - Public Properties

    let theme: Theme
    
    /// Convenience to get right at the text style
    var textStyleTheme: TextStyleTheme {
        return theme.textStyleTheme
    }
    
    /// Convenience to get right at the color theme
    var colorTheme: ColorTheme {
        return theme.colorTheme
    }
    
    /// Convenience to get right at the button style theme
    var buttonStyleTheme: ButtonStyleTheme {
        return theme.buttonStyleTheme
    }

    // MARK: - Initialization

    /// Default theme initializer.
    ///
    /// - Parameter theme: Application theme.
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
    }

    /// Initializer that exposes the frame.
    ///
    /// - Parameters:
    ///   - theme: Application theme.
    ///   - frame: View frame.
    init(theme: Theme, frame: CGRect) {
        self.theme = theme
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - BuildableView
extension ShimmerProtocol where Self: BuildableView {

    var shimmerColor: UIColor {
        return colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
    }

}
