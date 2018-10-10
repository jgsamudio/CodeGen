//
//  TextStyleTheme.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Marker

/// Text styles for the application. Should match designer's sketch file.
struct TextStyleTheme {

	// MARK: - Private Properties

    // MARK: - Private Properties
    
    /// Application color theme.
    private let colorTheme = ColorTheme()

    // MARK: - Body Set

    // MARK: - Public Properties
    
    var bodyNormal: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 15),
                         strongFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 15),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.2,
                         minimumLineHeight: 21,
                         paragraphSpacing: 14,
                         textAlignment: .left)
    }

    var bodyLarge: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 16),
                         strongFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 16),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 22,
                         textAlignment: .left)
    }

    var bodySmall: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 14),
                         strongFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 14),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 20,
                         textAlignment: .left,
                         lineBreakMode: .byTruncatingTail)
    }
        
    var bodySmallSpread: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 14),
                         strongFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 14),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 1.0,
                         minimumLineHeight: 20,
                         textAlignment: .left)
    }
    
    var bodyTiny: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 12),
                         strongFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 14),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.3,
                         minimumLineHeight: 16,
                         textAlignment: .left,
                         lineBreakMode: .byTruncatingTail)
    }

    // MARK: - Display Set

    var displayNormal: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewExtraBold(ofSize: 28),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: -0.5,
                         minimumLineHeight: 28,
                         textAlignment: .left)
    }
    
    var displayHuge: TextStyle {
        return TextStyle(font: BureauFonts.bureauGro35(ofSize: 38),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: 0.6,
                         minimumLineHeight: 40,
                         textAlignment: .left)
    }
    
    var displayExtraHuge: TextStyle {
        return TextStyle(font: BureauFonts.bureauGro35(ofSize: 53),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: -0.86,
                         minimumLineHeight: 56,
                         textAlignment: .left)
    }

    var displayLarge: TextStyle {
        return TextStyle(font: BureauFonts.bureauGro31(ofSize: 32),
                         strongFont: BureauFonts.bureauGro35(ofSize: 32),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: 0.6,
                         minimumLineHeight: 36,
                         textAlignment: .left)
    }

    var displaySmall: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewExtraBold(ofSize: 26),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: -0.54,
                         minimumLineHeight: 30,
                         textAlignment: .left)
    }
    
    // MARK: - Display Set
    
    /// For now, there is just this one script font. Eventually, I suspect they'll be more,
    /// and more names and a system will be required.
    var script: TextStyle {
        return TextStyle(font: TildaFonts.tildaPetite(ofSize: 40),
                         textColor: colorTheme.emphasisSecondary,
                         characterSpacing: -0.82,
                         minimumLineHeight: 32,
                         textAlignment: .center)
    }

    // MARK: - Caption Set

    var captionNormal: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNew(ofSize: 11),
                         strongFont: BiancoSansFonts.biancoSansNewBold(ofSize: 11),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.3,
                         minimumLineHeight: 16,
                         textAlignment: .left)
    }

    var captionLarge: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNew(ofSize: 13),
                         strongFont: BiancoSansFonts.biancoSansNewBold(ofSize: 13),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.3,
                         minimumLineHeight: 19,
                         textAlignment: .left)
    }

    var captionSmall: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNew(ofSize: 10),
                         strongFont: BiancoSansFonts.biancoSansNewBold(ofSize: 10),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.2,
                         minimumLineHeight: 14,
                         textAlignment: .left)
    }

    var captionBig: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNew(ofSize: 12),
                         emFont: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 12),
                         strongFont: BiancoSansFonts.biancoSansNewBold(ofSize: 12),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.2,
                         minimumLineHeight: 16,
                         textAlignment: .left)
    }

    // MARK: - Headline Set
    
    var headline0: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewBold(ofSize: 30),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: -0.3,
                         minimumLineHeight: 36,
                         textAlignment: .left)
    }

    var headline1: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 24),
                         emFont: BiancoSerifFonts.biancoSerifNewBold(ofSize: 24),
                         strongFont: BiancoSerifFonts.biancoSerifNewExtraBold(ofSize: 24),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: -0.3,
                         minimumLineHeight: 30,
                         textAlignment: .left)
    }

    var headline2: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewExtraBold(ofSize: 20),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: -0.3,
                         minimumLineHeight: 26,
                         textAlignment: .left)
    }
    
    var headline3: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewBold(ofSize: 18),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: -0.3,
                         minimumLineHeight: 24,
                         textAlignment: .left)
    }

    var headline4: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNewBold(ofSize: 16),
                         strongFont: BiancoSerifFonts.biancoSerifNewExtraBold(ofSize: 16),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 22,
                         textAlignment: .left)
    }

    var headline5: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 16),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 22,
                         textAlignment: .left)
    }

    // MARK: - Sub-Headline Set

    var subheadlineNormal: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 10),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.2,
                         minimumLineHeight: 14,
                         textAlignment: .left)
    }

    var subheadlineLarge: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 13),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 18,
                         textAlignment: .left)
    }

    var subheadlineSmall: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 9),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.0,
                         minimumLineHeight: 14,
                         textAlignment: .left)
    }
        
    var subheadlineBig: TextStyle {
        return TextStyle(font: BiancoSerifFonts.biancoSerifNew(ofSize: 11),
                         textColor: colorTheme.emphasisQuaternary,
                         characterSpacing: 0.3,
                         minimumLineHeight: 14,
                         textAlignment: .left)
    }

    // MARK: - Button Set

    var buttonTitleDarkRegular: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonTitleDarkEmphasis: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.emphasisQuaternaryFaded,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonTitleTintRegular: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.emphasisPrimary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonTitleTintEmphasis: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.emphasisPrimaryFaded,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonTitleWhiteRegular: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.invertTertiary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonTitleWhiteEmphasis: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.invertTertiaryFaded,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var buttonSmallTitleWhiteRegular: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 11),
                         emFont: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 11),
                         textColor: colorTheme.invertTertiary,
                         characterSpacing: 1.0,
                         minimumLineHeight: 13,
                         textAlignment: .center)
    }
    
    var buttonTitlePrimaryRegular: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.primary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }
    
    var buttonTitlePrimaryEmphasis: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.primaryFaded,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    // MARK: - Navigation Bar Set

    var navigationTitle: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.tertiary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }

    var navigationButton: TextStyle {
        return TextStyle(font: BiancoSansFonts.biancoSansNewExtraBold(ofSize: 13),
                         textColor: colorTheme.emphasisQuintary,
                         characterSpacing: 2.0,
                         minimumLineHeight: 1.2,
                         textAlignment: .center)
    }
    
}
