//
//  DefaultBackgroundOverlayDesigner.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Velar

final class DefaultBackgroundOverlayDesigner: BackgroundOverlayDesignable {

    // MARK: - Public Properties

    var dismissLabelText: String {
        return ""
    }

    var hideDismissLabel: Bool {
        return true
    }

    var dismissLabelColor: UIColor {
        return UIColor.white
    }

    var backgroundColor: UIColor {
        return theme.colorTheme.emphasisQuintary.withAlphaComponent(0.6)
    }

    // MARK: - Private Properties

    private let theme: Theme

    // MARK: - Initialization

    init(theme: Theme) {
        self.theme = theme
    }

}
