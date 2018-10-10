//
//  ViewConstants.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct ViewConstants {
    
    // MARK: - Public Properties
    
    static let dot = " • "
    
    static let profileDrawerInset: CGFloat = 41

    static let defaultGutter: CGFloat = 32
    
    static let defaultInsets = UIEdgeInsets(top: 0,
                                            left: ViewConstants.defaultGutter,
                                            bottom: 0,
                                            right: ViewConstants.defaultGutter)
    
    static let searchCellGutter: CGFloat = 12
    
    static let searchBarGutter: CGFloat = 8
    
    static let defaultButtonHeight: CGFloat = 44
    
    static let stylizedButtonTitleInset: CGFloat = 27

    static let headerGutter: CGFloat = 24

    static let defaultButtonSize = CGSize(width: 44, height: 44)
    
    static let defaultCTAButtonSize = CGSize(width: 130, height: 44)
    
    static let lineSeparatorThickness: CGFloat = 0.5

    static let navigationBarShadowOffset = CGSize(width: 0, height: -2)
    
    static let navigationBarShadowRadius: CGFloat = 15.0
    
    static let navigationBarShadowOpacity: Float = 0.2
    
    static let navigationBarThreshold: CGFloat = 20
    
    static let navigationBarAnimatedTop: CGFloat = -60
    
    static var navigationBarHeight: CGFloat {
        return UIScreen.isiPhoneXOrBigger ? 88 : 44
    }

    static var bottomButtonHeight: CGFloat {
        return UIScreen.isiPhoneXOrBigger ? 80 : 60
    }
    
    static let loadingIndicatorFooterFrame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 44)
    
    static let paginateScrollPercentage: CGFloat = 0.95
    
    static let defaultEventCellTrailingOffset: CGFloat = -65

    static let defaultWidth = UIScreen.width - ViewConstants.defaultGutter * 2

}
