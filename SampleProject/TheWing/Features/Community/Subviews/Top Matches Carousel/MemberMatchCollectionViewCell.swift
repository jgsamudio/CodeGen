//
//  MemberMatchCollectionViewCell.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberMatchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties

    private var memberMatchCellView: MemberMatchCellView?

    // MARK: - Public Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        memberMatchCellView?.cancelImageRequest()
    }
    
    /// Sets cell with theme and content.
    ///
    /// - Parameters:
    ///   - memberInfo: Member info content object.
    ///   - theme: Theme.
    func setup(memberInfo: MemberInfo?, theme: Theme, isLoading: Bool) {
        setupCellView(with: theme)
        memberMatchCellView?.setup(memberInfo: memberInfo, isLoading: isLoading)
    }
    
}

// MARK: - Private Functions
private extension MemberMatchCollectionViewCell {
    
    func setupCellView(with theme: Theme) {
        guard memberMatchCellView == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let cellView = MemberMatchCellView(theme: theme)
        contentView.addSubview(cellView)
        cellView.autoPinEdgesToSuperviewEdges()
        memberMatchCellView = cellView
    }
    
}
