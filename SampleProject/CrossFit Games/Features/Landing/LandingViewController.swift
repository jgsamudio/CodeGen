//
//  LandingViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//
import AVFoundation
import AVKit
import Simcoe
import UIKit

class LandingViewController: BaseAuthViewController {

    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var loginButton: StyleableButton!
    @IBOutlet private weak var createAccountButton: StyleableButton!
    @IBOutlet private weak var skipButton: StyleableButton!
    /// View model
    var viewModel: RootViewModel!

    let localization = LandingLocalization()

    private weak var videoPlayer: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPlayer?.play()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enteredBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enteringForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoPlayer?.pause()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    @IBAction private func didTapSignIn(_ sender: StyleableButton) {
        Simcoe.track(event: .landingSignIn,
                     withAdditionalProperties: [:], on: .landing)

        LandingViewController.promptForPush()

        let loginViewController = LoginBuilder().build()
        navigationController?.pushViewController(loginViewController, animated: true)
        viewModel.logout() // clears all user-related data in the app
    }

    @IBAction private func didTapCreateAccount(_ sender: StyleableButton) {
        Simcoe.track(event: .landingCreateAccount,
                     withAdditionalProperties: [:], on: .landing)

        LandingViewController.promptForPush()

        let createAccountNameEntryViewController = CreateAccountNameEntryBuilder().build()
        navigationController?.pushViewController(createAccountNameEntryViewController, animated: true)
    }

    @IBAction private func didTapSkip(_ sender: StyleableButton) {
        Simcoe.track(event: .landingSkip,
                     withAdditionalProperties: [:], on: .landing)

        UIView.fadePresentedViewController(to: MainNavigationBuilder().build(), completion: {
            LandingViewController.promptForPush()
        })
    }

    @objc private func enteredBackground() {
        videoPlayer?.pause()
    }

    @objc private func enteringForeground() {
        videoPlayer?.play()
    }

    private static func promptForPush() {
        if !PushNotifications.shared.didPromptBefore {
            PushNotifications.shared.updateRepromptCondition()
            PushNotifications.shared.promptIfNeeded(leavingLandingPage: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playVideo()
    }

    /// Manages the initial view controller configurations
    private func config() {
        loginButton.setTitle(localization.login, for: .normal)
        createAccountButton.setTitle(localization.createAnAccount, for: .normal)
        skipButton.setTitle(localization.skip, for: .normal)
        
        loginButton.backgroundColor = .white
        createAccountButton.applyBorder(withColor: .white, borderWidth: 1)

        /// Add observer to handle the video ending
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem,
                                               queue: nil,
                                               using: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.videoPlayer?.seek(to: kCMTimeZero)
                self?.videoPlayer?.play()
            }
        })
    }
    
    /// Initializes the AV player and set the local video file to the player
    /// and plays the video
    private func playVideo() {
        if let url = StandardFileManager.readFileURL(byPath: "landing_background_video", type: "mp4") {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback,
                                                             with: AVAudioSessionCategoryOptions.mixWithOthers)
            videoPlayer = AVPlayer(url: url)
            videoPlayer?.isMuted = true

            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.frame = videoView.bounds

            /// Fill the entire screen with the video
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoView.layer.addSublayer(playerLayer)
            videoPlayer?.play()
        }
    }

}
