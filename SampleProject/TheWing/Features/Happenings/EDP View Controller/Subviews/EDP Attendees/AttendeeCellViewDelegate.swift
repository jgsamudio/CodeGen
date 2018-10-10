//
//  AttendeeCellViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol AttendeeCellViewDelegate: class {

    /// Called when the member cell is selected.
    ///
    /// - Parameter memberInfo: Member info of the selected cell.
    func memberCellSelected(memberInfo: MemberInfo)

}
