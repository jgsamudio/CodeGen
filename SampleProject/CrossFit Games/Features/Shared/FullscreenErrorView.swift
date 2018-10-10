//
//  FullscreenErrorView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Error view for generic errors, designed to cover the whole or most of the screen.
final class FullscreenErrorView: UIView {

    // MARK: - Private Properties
    
    private static var killSwitchWindow: UIWindow!

    @IBOutlet private weak var titleLabel: StyleableLabel!
    @IBOutlet private weak var messageLabel: StyleableLabel!
    @IBOutlet private weak var button: StyleableButton!

    private let localization = GeneralLocalization()

    /// Tap action for the button.
    private var tapAction: (@escaping (Error?) -> Void) -> Void = { _ in }

    private let grayToneColor = UIColor(white: 59/255, alpha: 1)

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        button.backgroundColor = .clear
        button.layer.borderColor = grayToneColor.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 2
        button.setTitle(localization.errorRefresh, for: .normal)

        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    /// Covers the given view with a fullscreen error. On tap on the screen's button, the given closure will
    /// be run to retry the request. If the request fails again, the closure's completion block should be
    /// called with the error. If the request succeeds, the closure's completion block should be called with
    /// nil. Either way, the given closure **has to be called** in order to hide the error view.
    ///
    /// - Parameters:
    ///   - otherView: View to cover.
    ///   - onTap: Closure whose parameter has to be called as a completion block for the result of the retry
    ///     action.
    /// - Returns: An instance of the error view
    @discardableResult
    static func cover(_ otherView: UIView, onTap: @escaping (@escaping (Error?) -> Void) -> Void) -> FullscreenErrorView? {
        guard let errorView = UINib(nibName: String(describing: FullscreenErrorView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? FullscreenErrorView else {
                return nil
        }
        errorView.titleLabel.text = errorView.localization.errorTitle
        errorView.messageLabel.text = errorView.localization.errorMessage
        errorView.tapAction = onTap
        errorView.alpha = 0

        otherView.addSubview(errorView)
        errorView.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)
        UIView.animate(withDuration: 0.3) {
            errorView.alpha = 1
        }
        return errorView
    }

    static func presentWindow(title: String?, message: String?, onTap: @escaping (@escaping (Error?) -> Void) -> Void) {
        guard let errorView = UINib(nibName: String(describing: FullscreenErrorView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? FullscreenErrorView else {
                return
        }
        errorView.tapAction = onTap
        errorView.titleLabel.text = title ?? errorView.localization.errorTitle
        errorView.messageLabel.text = message ?? errorView.localization.errorMessage
        killSwitchWindow = KillSwitchWindow(frame: UIScreen.main.bounds)
    
    // MARK: - Public Properties
    
        let rootViewController = UIViewController()
        rootViewController.view.addSubview(errorView)
        rootViewController.view.backgroundColor = UIColor.red
        errorView.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)
        killSwitchWindow.rootViewController = rootViewController
        killSwitchWindow.windowLevel = UIWindowLevelAlert
        killSwitchWindow.makeKeyAndVisible()
    }

    @objc private func didTap() {
        button.isUserInteractionEnabled = false
        button.showLoading(withColor: grayToneColor)
        tapAction { [weak self] error in
            self?.button.hideLoading()
            self?.button.isUserInteractionEnabled = true
            guard error == nil else {
                return
            }

            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 0
            }, completion: { _ in
                self?.removeFromSuperview()
            })
        }
    }

}
