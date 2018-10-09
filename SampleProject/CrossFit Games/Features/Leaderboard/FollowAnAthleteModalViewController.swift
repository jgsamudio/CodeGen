//
//  FollowAnAthleteModalViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FollowAnAthleteModalViewController: UIViewController {

    @IBOutlet private weak var singleAthleteView: UIView!
    @IBOutlet private weak var multiAthleteView: UIView!
    @IBOutlet private weak var multiAthleteInnerView: UIView!
    @IBOutlet private weak var followingContentLabel: StyleableLabel!
    @IBOutlet private weak var singleAthleteProfileImageView: UIImageView!
    @IBOutlet private weak var multiAthleteFollowingContentLabel: StyleableLabel!
    @IBOutlet private weak var multiAthleteFollowingProfileImageView: UIImageView!
    @IBOutlet private weak var multiAthletePreviousProfileImageView: UIImageView!
    @IBOutlet private weak var singleAthleteInnerView: UIView!

    private let localization = LeaderboardLocalization()

    var viewModel: FollowAnAthleteViewModel!

    weak var delegate: FollowAnAthleteDelegate!

    /// Specifies if the modal view should support single athlete view or multi athlete view
    var isSingleAthleteView: Bool!

    private let imageSize: CGFloat = 48

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userPanned))
        panGesture.minimumNumberOfTouches = 1

        tapGesture.delegate = self
        panGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)

        singleAthleteView.layer.cornerRadius = 4
        singleAthleteInnerView.layer.cornerRadius = 4
        multiAthleteView.layer.cornerRadius = 4
        multiAthleteInnerView.layer.cornerRadius = 4

        loadFollowingAthleteView()

        if let viewModel = viewModel {
            if let isSingleAthleteView = isSingleAthleteView, isSingleAthleteView == true {
                followingContentLabel.text = localization.nowFollowing(with: viewModel.followingAthlete.name ?? "")

                formatImageView(imageView: singleAthleteProfileImageView, imageURL: viewModel.followingAthlete.imageUrls?.first)
            } else {
                if let previousAthlete = viewModel.previousAthlete {
                    formatImageView(imageView: multiAthletePreviousProfileImageView, imageURL: previousAthlete.imageUrls?.first, isFollowing: false)
                }

                multiAthleteFollowingContentLabel.text = localization.nowFollowing(with: viewModel.followingAthlete.name ?? "")
                formatImageView(imageView: multiAthleteFollowingProfileImageView, imageURL: viewModel.followingAthlete.imageUrls?.first)
            }
        }
    }

    @objc private func userPanned(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            dismissView()
        }
    }

    @objc private func userTapped(recognizer: UITapGestureRecognizer) {
        dismissView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }

    private func formatImageView(imageView: UIImageView, imageURL: URL?, isFollowing: Bool = true) {
        imageView.download(imageURL: imageURL)
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        if isFollowing {
            imageView.applyBorder(withColor: .white, borderWidth: 1)
        }

    }

    private func loadFollowingAthleteView() {
        var view: UIView!
        if isSingleAthleteView == true {
            view = singleAthleteView
            multiAthleteView.isHidden = true
        } else {
            view = multiAthleteView
            singleAthleteView.isHidden = true
        }

        UIView.animate(withDuration: 0.3,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                        view.alpha = 0
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0,
                                       usingSpringWithDamping: 0.65,
                                       initialSpringVelocity: 4.0,
                                       options: .allowUserInteraction,
                                       animations: {
                                        view.transform = .identity
                                        view.alpha = 1
                            },
                                       completion: nil)

        })
    }

    /// Removes the modal view
    @objc func dismissView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.alpha = 0.0
            self?.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { [weak self] finished in
            if finished {
                let delegate = self?.delegate
                self?.dismiss(animated: true, completion: nil)
                delegate?.modalDismissed()
            }
        })
    }

}

// MARK: - UIGestureRecognizerDelegate
extension FollowAnAthleteModalViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let isSingleAthleteView = isSingleAthleteView,
            isSingleAthleteView, singleAthleteView.bounds.contains(touch.location(in: singleAthleteView)) {
            return false
        } else if let isSingleAthleteView = isSingleAthleteView,
            !isSingleAthleteView, multiAthleteView.bounds.contains(touch.location(in: multiAthleteView)) {
            return false
        }
        return true
    }

}
