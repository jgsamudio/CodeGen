//
//  BookmarkButton.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

typealias BookmarkInfo = (isBookmarked: Bool, enableFeedback: Bool)

final class BookmarkButton: UIButton {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    // MARK: - Public Functions

    /// Sets the bookmark button with the info provided.
    ///
    /// - Parameter bookmarkInfo: Info of the bookmark
    func set(bookmarkInfo: BookmarkInfo) {
    
    // MARK: - Public Properties
    
        let bookmarkedImage = bookmarkInfo.isBookmarked ? #imageLiteral(resourceName: "bookmarked_button") : #imageLiteral(resourceName: "bookmark_button")
        setImage(bookmarkedImage, for: .normal)

        if bookmarkInfo.isBookmarked && bookmarkInfo.enableFeedback {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

}

// MARK: - Private Functions
private extension BookmarkButton {

    func setupButton() {
        set(bookmarkInfo: (false, false))
    }

}
