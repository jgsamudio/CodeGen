//
//  ColorTheme.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

/// Color theme of the wing application.
final class ColorTheme {

    // MARK: - Public Properties

    // MARK: - Primary colors.

    // MARK: - Public Properties
    
    // #07244F
    let primary = Colors.navy

    var primaryMuted: UIColor {
        return primary.brighten(by: Colors.defaultMuted)
    }

    var primaryFaded: UIColor {
        return primary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Secondary colors.

    // #F4DCD2
    let secondary = Colors.pink

    var secondaryMuted: UIColor {
        return secondary.brighten(by: Colors.defaultMuted)
    }

    var secondaryFaded: UIColor {
        return secondary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Tertiary colors.

    // #A4A6A8
    let tertiary = Colors.gray

    var tertiaryMuted: UIColor {
        return tertiary.brighten(by: 0.3)
    }

    var tertiaryFaded: UIColor {
        return tertiary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Emphasis primary colors.

    // #DF7F57
    let emphasisPrimary = Colors.clipboard

    var emphasisPrimaryMuted: UIColor {
        return emphasisPrimary.brighten(by: Colors.defaultMuted)
    }

    var emphasisPrimaryFaded: UIColor {
        return emphasisPrimary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Emphasis secondary colors.

    // #D28C0E
    let emphasisSecondary = Colors.ochre

    var emphasisSecondaryMuted: UIColor {
        return emphasisSecondary.brighten(by: Colors.defaultMuted)
    }

    var emphasisSecondaryFaded: UIColor {
        return emphasisSecondary.withAlphaComponent(0.15)
    }

    // MARK: - Emphasis Tertiary colors.

    // #D5F4E1
    let emphasisTertiary = Colors.mint

    var emphasisTertiaryMuted: UIColor {
        return emphasisTertiary.brighten(by: Colors.defaultMuted)
    }

    var emphasisTertiaryFaded: UIColor {
        return emphasisTertiary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Emphasis Quaternary colors.

    // #56595B
    let emphasisQuaternary = Colors.darkGray

    var emphasisQuaternaryMuted: UIColor {
        return emphasisQuaternary.brighten(by: Colors.defaultMuted)
    }

    var emphasisQuaternaryFaded: UIColor {
        return emphasisQuaternary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Emphasis Quintary colors.

    // #000000
    let emphasisQuintary = Colors.black

    var emphasisQuintaryMuted: UIColor {
        return emphasisQuintary.brighten(by: Colors.defaultMuted)
    }

    var emphasisQuintaryFaded: UIColor {
        return emphasisQuintary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Invert primary colors.

    // #FBF1ED
    let invertPrimary = Colors.pinkWeb

    var invertPrimaryMuted: UIColor {
        return invertPrimary.brighten(by: Colors.defaultMuted)
    }

    var invertPrimaryFaded: UIColor {
        return invertPrimary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Invert secondary colors.

    // #EEF7F1
    let invertSecondary = Colors.mintWeb

    var invertSecondaryMuted: UIColor {
        return invertSecondary.brighten(by: Colors.defaultMuted)
    }

    var invertSecondaryFaded: UIColor {
        return invertSecondary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Invert Tertiary colors.

    // #FFFFFF
    let invertTertiary = Colors.white

    var invertTertiaryMuted: UIColor {
        return invertTertiary.darken(by: 0.05)
    }

    var invertTertiaryFaded: UIColor {
        return invertTertiary.withAlphaComponent(Colors.defaultFaded)
    }

    // MARK: - Error colors.

    // #E80C0C
    let errorPrimary = Colors.red

    var errorPrimaryMuted: UIColor {
        return errorPrimary.brighten(by: Colors.defaultMuted)
    }

    var errorPrimaryFaded: UIColor {
        return emphasisTertiary.withAlphaComponent(Colors.defaultFaded)
    }

}
