//
//  WorkoutCell.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import AlamofireImage

final class WorkoutCell: UITableViewCell {

    @IBOutlet private weak var workoutImageView: UIImageView!
    @IBOutlet private weak var titleLabel: StyleableLabel!
    @IBOutlet private weak var scoreSubmissionView: UIView!
    @IBOutlet private weak var workoutSummaryView: UIView!
    @IBOutlet private weak var sponsorLogoImageView: UIImageView!
    @IBOutlet private weak var submissionTimeLabel: StyleableLabel!
    @IBOutlet private(set) weak var submitScoreButton: StyleableButton!
    @IBOutlet private weak var tintView: UIView!
    /// Median value of the estimated row heights
    static let rowHeight: CGFloat = 300
    private let logoImageHeight: CGFloat = 24

    let localization = WorkoutsLocalization()

    /// Callback for the submit score button.
    var submitScoreCallback: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    private func config() {
        applyRoundedCorners(radius: 4)
        sponsorLogoImageView.tintColor = .white
        submitScoreButton.backgroundColor = StyleColumn.c3.color
        submitScoreButton.setTitle(localization.submitScore, for: .normal)
        scoreSubmissionView.isHidden = false
    }

    private func applyRoundedCorners(radius: CGFloat) {
        workoutSummaryView.layer.cornerRadius = radius
        workoutImageView.layer.cornerRadius = radius
        tintView.layer.cornerRadius = radius
    }

    /// Sets workout details
    ///
    /// - Parameter workout: workout view model
    func setData(workout: WorkoutViewModel) {
        titleLabel.text = workout.title

        scoreSubmissionView.isHidden = workout.isCompleted

        workoutImageView.download(imageURL: workout.workoutImageURL)
        if let sponsorImageURL = workout.sponsorImageURL {
            sponsorLogoImageView.af_setImage(withURL: sponsorImageURL, completion: { [weak self] (response) in
                if let image = response.result.value, let logoImageHeight = self?.logoImageHeight {
                    let aspectRatio: CGFloat = image.size.width / image.size.height
                    let width: CGFloat = logoImageHeight * aspectRatio
                    let height: CGFloat = logoImageHeight

                    self?.sponsorLogoImageView.image = image.af_imageAspectScaled(toFit:
                        CGSize(width: width,
                               height: height)).withRenderingMode(.alwaysTemplate)
                    self?.sponsorLogoImageView.tintColor = .white
                }
            })
        }

        if let submissionTime = workout.formattedSubmissionTime {
            let submissionTimeText = "\(localization.submissionDeadline)\n\(submissionTime)"
            submissionTimeLabel.text = submissionTimeText

            let attributes = submissionTimeLabel.attributedText?.attributes(at: 0,
                                                                            longestEffectiveRange: nil,
                                                                            in: NSRange(location: 0,
                                                                                        length: submissionTimeText.count))

            let attributtedString = NSMutableAttributedString(string: submissionTimeText,
                                                              attributes: attributes)

            attributtedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                           value: StyleColumn.c5.color,
                                           range: NSRange(location: 0, length: localization.submissionDeadline.count))

            submissionTimeLabel.attributedText = attributtedString

        }
    }

    @IBAction private func submitScore() {
        submitScoreCallback()
    }

}
