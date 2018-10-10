//
//  MemberTableViewCell.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private var memberCellView: MemberCellView?
    
    // MARK: - Public Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberCellView?.cancelImageRequest()
    }
    
    /// Sets member cell view with given inputs.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - memberInfo: Info for the member.
    ///   - category: Member search category.
    func setup(theme: Theme,
               memberInfo: MemberInfo?,
               category: MemberSearchCategory = .unfiltered,
               isLoading: Bool = false) {
        setupCellView(theme: theme)
        memberCellView?.setup(memberInfo: memberInfo, category: category, isLoading: isLoading)
    }

}

// MARK: - Private Functions
private extension MemberTableViewCell {
    
    func setupCellView(theme: Theme) {
        guard self.memberCellView?.superview == nil else {
            return
        }
        backgroundColor = UIColor.clear
        selectionStyle = .none
    
    // MARK: - Public Properties
    
        let memberCellView = MemberCellView(theme: theme)
        memberCellView.isUserInteractionEnabled = false
        contentView.addSubview(memberCellView)
        memberCellView.autoPinEdgesToSuperviewEdges()
        self.memberCellView = memberCellView
    }
    
}
