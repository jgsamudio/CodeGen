//
//  LeaderboardAthleteResultCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import AlamofireImage
import UIKit

/// Table view cell for displaying athletes in a leaderboard.
final class LeaderboardAthleteResultCell: UITableViewCell {

    // MARK: - Public Properties
    
    /// Height estimate for `self`.
    static let heightEstimate: CGFloat = 80

    // MARK: - Private Properties
    
    @IBOutlet private weak var athleteNameLabel: UILabel!

    @IBOutlet private weak var bottomLine: UIView!

    @IBOutlet private weak var athleteSublineLabel: UILabel!

    @IBOutlet private weak var athleteRankLabel: UILabel!

    @IBOutlet private weak var profilePicImageView: UIImageView!

    @IBOutlet private weak var secondAthleteProfilePicImageView: UIImageView!

    @IBOutlet private weak var leaderBadge: UILabel!

    @IBOutlet private weak var leaderBadgeView: UIView!

    /// Follow an Athlete action image view
    @IBOutlet weak var faaActionButton: StyleableButton!

    // Not weak as they are activated/deactivated which would remove the constraint on deactivation.
    @IBOutlet private var imageTextConstraint: NSLayoutConstraint!
    @IBOutlet private var leaderBadgeConstraint: NSLayoutConstraint!

    @IBOutlet private weak var expandedView: UIView!

    @IBOutlet private weak var scoreStackView: UIStackView!

    @IBOutlet private weak var leaderBadgeWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var leaderBadgeYPositionConstraint: NSLayoutConstraint!

    private let expandedBottomSpacing: CGFloat = 8

    private let localization = LeaderboardLocalization()

    private let placeholderImage = UIImage(named: "dashboardOutline")

    /// Indexpath of the relevant cell
    var indexPath: IndexPath!

    /// Explicitly hides the follow an athlete button
    var shouldHideFAAButton: Bool!

    private var isLeaderCell: Bool {
        return viewModel?.rank.flatMap(Int.init) == 1
    }

    weak var followAnAthleteDelegate: FollowAnAthleteDelegate!

    var viewModel: LeaderboardAthleteResultCellViewModel? {
        didSet {
            imageUrl = viewModel?.imageUrls?.first
            secondImageUrl = viewModel?.imageUrls?.dropFirst().first
            let rank = viewModel?.rank
            self.rank = rank
            if isLeaderCell {
                leaderBadgeConstraint.isActive = false
                self.rank = nil
                badgeBackgroundColor = StyleColumn.c2.color
                leaderText = localization.leader.uppercased()
            } else {
                leaderText = nil
            }

            if isExpanded {
                setupStackView()
            }

            setLabels()
        }
    }

    /// Indicates whether or not the cell is expanded.
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                setupStackView()
            }
            if shouldHideFAAButton == true {
                faaActionButton.isHidden = true
            } else if isExpanded {
                faaActionButton.isHidden = viewModel?.isCurrentUser == true
            } else {
                faaActionButton.isHidden = true
            }

            expandedView.isHidden = !isExpanded
            setLabels()

            if !isLeaderCell && isExpanded {
                leaderBadgeConstraint.isActive = true
                leaderBadgeView.backgroundColor = .clear
            } else if !isLeaderCell {
                leaderBadgeConstraint.isActive = false
                leaderBadgeView.backgroundColor = .clear
            }

            if isExpanded {
                bottomLine.alpha = 1
                leaderBadgeWidthConstraint.constant = -expandedBottomSpacing
                leaderBadgeYPositionConstraint.constant = -expandedBottomSpacing / 2
                athleteSublineLabel.numberOfLines = 0
                displayFaaButtonIcon()
            } else {
                bottomLine.alpha = 0
                leaderBadgeWidthConstraint.constant = 0
                leaderBadgeYPositionConstraint.constant = 0
                athleteSublineLabel.numberOfLines = 1
            }
        }
    }

    /// The athlete's rank.
    private var rank: String? {
        didSet {
            athleteRankLabel.text = rank
        }
    }

    /// Image url to load for the profile picture.
    private var imageUrl: URL? {
        didSet {
            profilePicImageView.download(imageURL: imageUrl)
        }
    }

    /// Image URL for a second athlete (if any).
    private var secondImageUrl: URL? {
        didSet {
            secondAthleteProfilePicImageView.isHidden = secondImageUrl == nil
            imageTextConstraint.isActive = secondImageUrl != nil
            secondAthleteProfilePicImageView.download(imageURL: secondImageUrl)
        }
    }

    /// Text for the badge on the left hand side of the cell.
    private var leaderText: String? {
        didSet {
            leaderBadge.text = leaderText
        }
    }

    /// Background color for the badge on the left hand side of the cell.
    private var badgeBackgroundColor: UIColor? {
        didSet {
            leaderBadgeView.backgroundColor = badgeBackgroundColor
        }
    }

    private let imageSize: CGFloat = 40

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profilePicImageView.layer.cornerRadius = imageSize / 2
        secondAthleteProfilePicImageView.layer.cornerRadius = imageSize / 2
        secondAthleteProfilePicImageView.layer.masksToBounds = true
        profilePicImageView.layer.masksToBounds = true

        // Rotate leaderbadge appropriately.
        leaderBadgeView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        leaderBadgeView.transform = .init(rotationAngle: -1 * .pi / 2)
    }

    @IBAction func didTapFaaAction(_ sender: StyleableButton) {
        faaActionButton.setImage(nil, for: .normal)
        faaActionButton.startActivityIndicator()

        if let athleteId = viewModel?.id {
            if let currentFollowingAthleteId = viewModel?.getFollowingAthlete(),
                currentFollowingAthleteId == athleteId {
                if let delegate = followAnAthleteDelegate, let indexPath = indexPath {
                    delegate.didTap(isAdded: false,
                                    indexPath: indexPath, athleteId: nil)
                }
            } else if let currentFollowingAthleteId = viewModel?.getFollowingAthlete(),
                currentFollowingAthleteId != athleteId {
                if let delegate = followAnAthleteDelegate, let indexPath = indexPath {
                    delegate.didTap(isAdded: true,
                                    indexPath: indexPath, athleteId: athleteId)
                }
            } else {
                if let delegate = followAnAthleteDelegate, let indexPath = indexPath {
                    delegate.didTap(isAdded: true,
                                    indexPath: indexPath, athleteId: athleteId)
                }
            }
        }
    }

    private func displayFaaButtonIcon() {
        guard let athleteId = viewModel?.id else {
            return
        }
        faaActionButton.stopActivityIndicator()
        if let currentFollowingAthleteId = viewModel?.getFollowingAthlete(),
            currentFollowingAthleteId == athleteId {
            faaActionButton.setImage(#imageLiteral(resourceName: "faa following icon"), for: .normal)
        } else {
            faaActionButton.setImage(#imageLiteral(resourceName: "faa add icon"), for: .normal)
        }
    }

    private func setupStackView() {
        scoreStackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }

        let workoutNameStack = UIStackView(arrangedSubviews: viewModel?.workoutNames.map(createWorkoutNameLabel) ?? [])
        let workoutRankStack = UIStackView(arrangedSubviews: viewModel?.ranks.map(createWorkoutRankLabel) ?? [])
        let workoutScoreStack = UIStackView(arrangedSubviews: viewModel?.scores.map(createWorkoutScoreLabel) ?? [])

        [workoutNameStack, workoutRankStack, workoutScoreStack].forEach { (stackView) in
            stackView.axis = .vertical
            stackView.spacing = 6
            scoreStackView.addArrangedSubview(stackView)
        }
    }

    private func set(region: String?, scores: String?, age: String?, height: String?, weight: String?) {
        let displayedValues = [region, scores, age, height, weight].filter { $0?.isEmpty == false }

        let firstLine = displayedValues.flatMap({ $0 }).filter({ !$0.isEmpty }).prefix(2).joined(separator: "  •  ")
        let secondLine = displayedValues.flatMap({ $0 }).filter({ !$0.isEmpty }).dropFirst(2).prefix(3).joined(separator: "  •  ")
        let displayedText = (secondLine.isEmpty || !isExpanded) ? firstLine : [firstLine, secondLine].joined(separator: "\n")
        athleteSublineLabel.text = displayedText
    }

    private func createWorkoutNameLabel(name: String) -> UILabel {
        let label = StyleableLabel(frame: .zero)
        label.row = 2
        label.column = 5
        label.weight = 2
        label.text = name
        return label
    }

    private func createWorkoutScoreLabel(score: String) -> UILabel {
        let label = StyleableLabel(frame: .zero)
        label.row = 2
        label.column = 4
        label.weight = 2
        label.text = score
        if let attributedText = label.attributedText {
            let coloredText = StringConverter.setAttributes(attributes: StyleGuide.shared.style(row: 2, column: 5, weight: 2),
                                                            when: { "\($0)".rangeOfCharacter(from: CharacterSet.letters) != nil },
                                                            in: attributedText)
            label.attributedText = StringConverter.removeLineSpacing(from: coloredText)
        }
        return label
    }

    private func createWorkoutRankLabel(rank: String) -> UILabel {
        let label = StyleableLabel(frame: .zero)
        label.row = 2
        label.column = 4
        label.weight = 2
        label.text = rank
        if let attributedText = label.attributedText {
            let coloredText = StringConverter.setAttributes(attributes: StyleGuide.shared.style(row: 2, column: 5, weight: 2),
                                                            when: { "\($0)".rangeOfCharacter(from: CharacterSet.letters) != nil },
                                                            in: attributedText)
            label.attributedText = StringConverter.removeLineSpacing(from: coloredText)
        }
        return label
    }

    private func setLabels() {
        athleteNameLabel.text = viewModel?.name
        let ageString = viewModel?.age.flatMap {
            localization.ageString(age: $0)
        }
        set(region: viewModel?.region, scores: viewModel?.displayScore, age: ageString, height: viewModel?.height, weight: viewModel?.weight)
    }

}
