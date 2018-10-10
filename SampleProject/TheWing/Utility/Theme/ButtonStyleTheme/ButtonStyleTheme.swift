//
//  ButtonStyleTheme.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Button style themes for the application.
struct ButtonStyleTheme {
    
    // MARK: - Private Properties
    
    private let colorTheme = ColorTheme()
    private let textStyleTheme = TextStyleTheme()
    
    private let defaultBorderWidth: CGFloat = 1.0
    private let defaultCornerRadius: CGFloat = 0.0
    
    // MARK: - Primary Button Styles
    
    // MARK: - Public Properties
    
    var primaryLightButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkRegular,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisTertiary,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkEmphasis,
                                                  border: nil,
                                                  backgroundColor: colorTheme.emphasisTertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var primaryDarkButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisPrimary,
                                                cornerRadius: defaultCornerRadius)
        
        let titleTextStyle = textStyleTheme.buttonTitleWhiteEmphasis.withColor(Colors.white)
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: titleTextStyle,
                                                  border: nil,
                                                  backgroundColor: colorTheme.tertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    // MARK: - Secondary Button Styles
    
    var secondaryLightButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        let disabledBorder = Border(color: colorTheme.emphasisQuintaryFaded, width: defaultBorderWidth)
        
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkRegular,
                                                border: border,
                                                backgroundColor: colorTheme.invertTertiary,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkEmphasis,
                                                  border: disabledBorder,
                                                  backgroundColor: colorTheme.invertTertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var secondaryDarkButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        let disabledBorder = Border(color: colorTheme.emphasisQuintaryFaded, width: defaultBorderWidth)
        
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkRegular,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisTertiary,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleDarkEmphasis,
                                                  border: disabledBorder,
                                                  backgroundColor: colorTheme.invertPrimaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }

    var secondaryDarkSmallButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        let disabledBorder = Border(color: colorTheme.emphasisQuintaryFaded, width: defaultBorderWidth)
        let textStyle = textStyleTheme.bodySmall.withStrongFont().withColor(colorTheme.emphasisQuintary)

        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyle,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisTertiary,
                                                cornerRadius: defaultCornerRadius)

        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyle,
                                                  border: disabledBorder,
                                                  backgroundColor: colorTheme.invertPrimaryFaded,
                                                  cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }

    var secondaryThreeButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.emphasisSecondary,
                                                cornerRadius: defaultCornerRadius)
        
        let highlightedStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                     border: nil,
                                                     backgroundColor: colorTheme.emphasisSecondaryMuted,
                                                     cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                  border: nil,
                                                  backgroundColor: colorTheme.tertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle,
                           highlightedStyle: highlightedStateStyle,
                           disabledStyle: disabledStateStyle)
    }
    
    var secondaryFourButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.primary,
                                                cornerRadius: defaultCornerRadius)
        
        let highlightedStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                     border: nil,
                                                     backgroundColor: colorTheme.primaryMuted,
                                                     cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                  border: nil,
                                                  backgroundColor: colorTheme.tertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle,
                           highlightedStyle: highlightedStateStyle,
                           disabledStyle: disabledStateStyle)
    }
    
    var secondaryFiveButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.emphasisPrimary,
                                                cornerRadius: defaultCornerRadius)
        
        let highlightedStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                     border: nil,
                                                     backgroundColor: colorTheme.emphasisPrimaryMuted,
                                                     cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                  border: nil,
                                                  backgroundColor: colorTheme.tertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle,
                           highlightedStyle: highlightedStateStyle,
                           disabledStyle: disabledStateStyle)
    }
    
    // MARK: - Tertiary Button Styles
    
    var tertiaryButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisPrimary, width: defaultBorderWidth)
        let highlightedBorder = Border(color: colorTheme.emphasisPrimary, width: 2.0)
        let disabledBorder = Border(color: colorTheme.emphasisPrimaryFaded, width: 2.0)
        
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintRegular,
                                                border: border,
                                                backgroundColor: colorTheme.invertTertiary,
                                                cornerRadius: defaultCornerRadius)
        
        let highlightedStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintRegular,
                                                     border: highlightedBorder,
                                                     backgroundColor: colorTheme.invertTertiary,
                                                     cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintEmphasis,
                                                  border: disabledBorder,
                                                  backgroundColor: colorTheme.invertTertiaryFaded,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle,
                           highlightedStyle: highlightedStateStyle,
                           disabledStyle: disabledStateStyle)
    }

    // MARK: - Quaternary Button Styles

    var quaternaryButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: border,
                                                backgroundColor: colorTheme.primary,
                                                cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: normalStateStyle)
    }

    // MARK: - Quintary Button Styles

    var quintaryButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: defaultBorderWidth)
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisSecondary,
                                                cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: normalStateStyle)
    }

    // MARK: - Floating Text Button Styles
    
    var primaryFloatingButtonStyle: ButtonStyle {
        let border = Border(color: colorTheme.emphasisQuintary, width: 1.0)
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: border,
                                                backgroundColor: colorTheme.emphasisPrimary,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                  border: border,
                                                  backgroundColor: colorTheme.tertiaryMuted,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var floatingTextDarkButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintRegular,
                                                border: nil,
                                                backgroundColor: UIColor.clear,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintEmphasis,
                                                  border: nil,
                                                  backgroundColor: UIColor.clear,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var floatingTextPrimaryButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitlePrimaryRegular,
                                                border: nil,
                                                backgroundColor: UIColor.clear,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitlePrimaryEmphasis,
                                                  border: nil,
                                                  backgroundColor: UIColor.clear,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var floatingTextLightButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: UIColor.clear,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleWhiteEmphasis,
                                                  border: nil,
                                                  backgroundColor: UIColor.clear,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    var floatingTextInlineButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintRegular,
                                                border: nil,
                                                backgroundColor: UIColor.clear,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintEmphasis,
                                                  border: nil,
                                                  backgroundColor: UIColor.clear,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }
    
    // MARK: - In Cell Button Styles
    
    var inCellNormalButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintRegular,
                                                border: nil,
                                                backgroundColor: UIColor.clear,
                                                cornerRadius: defaultCornerRadius)
        
        let disabledStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonTitleTintEmphasis,
                                                  border: nil,
                                                  backgroundColor: UIColor.clear,
                                                  cornerRadius: defaultCornerRadius)
        
        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: disabledStateStyle)
    }

    // MARK: - Small RSVP Button Styles

    var smallRSVPButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonSmallTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.emphasisPrimary,
                                                cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: normalStateStyle)
    }

    // MARK: - Small Cancel Button Styles

    var smallCancelButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonSmallTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.primary,
                                                cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: normalStateStyle)
    }

    // MARK: - Small Waitlist Button Styles

    var smallWaitlistButtonStyle: ButtonStyle {
        let normalStateStyle = ButtonStateStyle(titleTextStyle: textStyleTheme.buttonSmallTitleWhiteRegular,
                                                border: nil,
                                                backgroundColor: colorTheme.emphasisSecondary,
                                                cornerRadius: defaultCornerRadius)

        return ButtonStyle(normalStyle: normalStateStyle, disabledStyle: normalStateStyle)
    }

}
