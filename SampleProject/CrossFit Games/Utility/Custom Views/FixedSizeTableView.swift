//
//  FixedSizeTableView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class FixedSizeTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()

        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
