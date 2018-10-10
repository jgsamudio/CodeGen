//
//  UIScrollView+CrossFit.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/1/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIScrollView {

    // MARK: - Public Functions
    
    /// Triggers scrollview to listen to keyboard events (show & hide)
    /// Appropriately offsets contentInset of scrollview to handle keyboard show/hide actions
    func enableKeyboardOffset() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    /// Disables scrollview from adjusting its contentInset due to keyboard show/hide actions
    func disableKeyboardOffset() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize: CGSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        contentInset.bottom = keyboardSize.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        contentInset.bottom = 0
    }

}
