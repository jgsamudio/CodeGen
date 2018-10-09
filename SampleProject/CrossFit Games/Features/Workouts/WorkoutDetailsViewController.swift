//
//  WorkoutDetailsViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import FlexiblePageControl
import Simcoe

final class WorkoutDetailsViewController: BaseViewController {

    private enum SegmentOptions: Int {
        case movementStandards = 0
        case workoutDescription

        func localize(localization: WorkoutDetailsLocalization) -> String {
            switch self {
            case .movementStandards:
                return localization.movementStandards
            case .workoutDescription:
                return localization.workoutDescription
            }
        }
    }

    @IBOutlet private weak var videoPlayerView: YTPlayerView!
    @IBOutlet private weak var workoutDivisionLabel: UILabel!
    @IBOutlet private weak var workoutTypeLabel: UILabel!
    @IBOutlet private weak var workoutDescriptionLabel: UILabel!
    @IBOutlet private weak var divisionDropdownImageView: UIImageView!
    @IBOutlet private weak var typeDropdownImageView: UIImageView!
    @IBOutlet private weak var stepNumberLabel: UILabel!
    @IBOutlet private weak var stepDescriptionLabel: UILabel!
    @IBOutlet private weak var pdfView: UIView!
    @IBOutlet private weak var stepImageStackView: UIStackView!
    @IBOutlet private weak var stepImageScrollView: UIScrollView!
    @IBOutlet private weak var sponsorImageView: UIImageView!
    @IBOutlet private weak var descriptionSponsorImageView: UIImageView!
    @IBOutlet private weak var submitScoreView: UIView!

    // MARK: - Stack view elements
    @IBOutlet private weak var workoutSelectionBar: UIView!
    @IBOutlet private weak var workoutDescriptionView: UIView!
    @IBOutlet private weak var toggleView: UIView!
    @IBOutlet private weak var carouselView: UIView!
    @IBOutlet private weak var notesView: UIView!
    @IBOutlet private weak var tiebreakerView: UIView!
    @IBOutlet private weak var pdfSponsorView: UIView!
    @IBOutlet private weak var equipmentButtonView: UIView!
    @IBOutlet private weak var videoSubmissionStandardButtonView: UIView!
    @IBOutlet private weak var equipmentButtonViewLabel: StyleableLabel!
    @IBOutlet private weak var videoSubmissionButtonViewLabel: StyleableLabel!
    @IBOutlet private weak var eqiupmentBottomBorderView: UIView!
    @IBOutlet private weak var videoSubmissionBottomBorderView: UIView!
    @IBOutlet private weak var carouselBottomBorderView: UIView!
    @IBOutlet private weak var tiebreakBottomBorderView: UIView!
    @IBOutlet private weak var descriptionSponsorARConstraint: NSLayoutConstraint!
    @IBOutlet private weak var notesLabel: StyleableLabel!
    @IBOutlet private weak var tiebreakLabel: StyleableLabel!
    @IBOutlet private weak var workoutDescriptionSegmentControl: StyleableSegmentControl!
    @IBOutlet private weak var downloadButton: StyleableButton!
    @IBOutlet private weak var scorecardPDFLabel: StyleableLabel!
    @IBOutlet private weak var sponsoredByLabel: StyleableLabel!
    @IBOutlet private weak var pageControl: FlexiblePageControl!
    @IBOutlet private weak var submissionTimeLabel: StyleableLabel!
    @IBOutlet private weak var submitScoreButton: StyleableButton!

    private var shouldPlayVideo = true
    var viewModel: WorkoutViewModel!

    private let localization = WorkoutDetailsLocalization()
    private let workoutsLocalization = WorkoutsLocalization()
    private let descriptionSponsorImageHeight: CGFloat = 32
    private let movementStandardSeparation: CGFloat = 32
    private let scrollViewDecelerationRate: CGFloat = 0.995
    private let selectedDotColor = UIColor(displayP3Red: 26/255,
                                           green: 99/255,
                                           blue: 186/255,
                                           alpha: 1.0)

    private let deselectedDotColorOpacity: CGFloat = 0.32

    /// Analytics: Movement standard swiping should only be tracked the first time.
    private var didTrackMovementStandardSwipe = false

    /// Analytics: Workout description viewing should only be tracked the first time.
    private var didTrackWorkoutDescriptionSegment = false

    /// Analytics: Video playing/enlarging
    private var didPlayVideo = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationController?.navigationBar.tintColor = StyleColumn.c2.color
        title = viewModel.title
        videoPlayerView.delegate = self

        config()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldPlayVideo, let videoId = viewModel.videoId {
            videoPlayerView.load(withVideoId: videoId)
        }
        shouldPlayVideo = false
    }

    private func config() {
        equipmentButtonViewLabel.text = localization.equipment
        videoSubmissionButtonViewLabel.text = localization.videoSubmissionStandards
        submitScoreButton.backgroundColor = StyleColumn.c3.color
        submitScoreButton.setTitle(localization.submitScore, for: .normal)
        notesLabel.attributedText = viewModel.workoutDescription
        tiebreakLabel.attributedText = viewModel.tiebreak
        sponsoredByLabel.text = localization.sponsoredBy
        scorecardPDFLabel.text = localization.scorecardPDF
        if let formattedSubmissionTime = viewModel.formattedSubmissionTime {
            submissionTimeLabel.text = localization.submissionTimeString(time: formattedSubmissionTime)
        }

        /// Dwcription segment control related configs
        workoutDescriptionSegmentControl.setTitle(SegmentOptions.movementStandards.localize(localization: localization),
                                                  forSegmentAt: SegmentOptions.movementStandards.rawValue)
        workoutDescriptionSegmentControl.setTitle(SegmentOptions.workoutDescription.localize(localization: localization),
                                                  forSegmentAt: SegmentOptions.workoutDescription.rawValue)
        handleSegmentControlChange(index: SegmentOptions.movementStandards.rawValue)

        downloadButton.setTitle(localization.download, for: .normal)
        
        /// Hiding the views if no data is available
        if viewModel.equipment == nil {
            equipmentButtonView(isHidden: true)
        }
        if viewModel.videoSubmissionStandards == nil {
            videoSubmissionButtonView(isHidden: true)
        }
        submitScoreView.isHidden = !viewModel.isLiveWorkout

        layoutWorkoutDescription()
        [descriptionSponsorImageView, sponsorImageView].forEach { (imageView) in
            guard let imageUrl = viewModel.sponsorImageURL else {
                imageView?.image = nil
                return
            }
            imageView?.af_setImage(withURL: imageUrl, completion: { [weak self] response in
                guard let image = response.value, let wself = self else {
                    return
                }
                self?.descriptionSponsorARConstraint.constant = image.size.width / image.size.height * wself.descriptionSponsorImageHeight
            })
        }

        equipmentButtonView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(WorkoutDetailsViewController
                                                            .didTapEquipmentButtonView(gestureRecognizer:))))
        videoSubmissionStandardButtonView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(WorkoutDetailsViewController
                                                            .didTapVideoSubmissionButtonView(gestureRecognizer:))))
        sponsorImageView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(WorkoutDetailsViewController
                                                            .didTapSponsorImageViewView(gestureRecognizer:))))

        equipmentButtonView.isHidden = viewModel.equipment?.string.isEmpty ?? true
        videoSubmissionStandardButtonView.isHidden = viewModel?.videoSubmissionStandards?.string.isEmpty ?? true

        populateStackImageStackView()
        videoPlayerView.layoutIfNeeded()
    }

    @objc private func didTapEquipmentButtonView(gestureRecognizer: UITapGestureRecognizer) {
        if let equipment = viewModel.equipment {
            showAdditionalInformation(content: equipment)
            Simcoe.track(event: .workoutEquipment,
                         withAdditionalProperties: [.id: viewModel.workout.id,
                                                    .workout: viewModel.title ?? ""],
                         on: .workoutPages)
        }
    }

    @objc private func didTapVideoSubmissionButtonView(gestureRecognizer: UITapGestureRecognizer) {
        if let videoSubmissionStandards = viewModel.videoSubmissionStandards {
            showAdditionalInformation(content: videoSubmissionStandards)
            Simcoe.track(event: .workoutVideoSubmission,
                         withAdditionalProperties: [.id: viewModel.workout.id,
                                                    .workout: viewModel.title ?? ""],
                         on: .workoutPages)
        }
    }

    @objc private func didTapSponsorImageViewView(gestureRecognizer: UITapGestureRecognizer) {
        guard let url = viewModel.sposorURL else {
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction private func downloadPDF(_ sender: UIButton) {
        if let pdfURL = viewModel.pdfURL {
            let pdfViewController = WebViewBuilder(url: pdfURL).build()
            navigationController?.pushViewController(pdfViewController, animated: true)
        }

    }

    @IBAction func didChangeDescriptionControl(_ sender: UISegmentedControl) {
        handleSegmentControlChange(index: sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case SegmentOptions.workoutDescription.rawValue where !didTrackWorkoutDescriptionSegment:
            didTrackWorkoutDescriptionSegment = true
            Simcoe.track(event: .workoutDescription,
                         withAdditionalProperties: [.id: viewModel.workout.id,
                                                    .workout: viewModel.title ?? ""],
                         on: .workoutPages)
        default:
            break
        }
    }

    @IBAction private func selectDivision() {
        let rows = viewModel.divisions.map { (value) -> PickerViewRow in
            return PickerViewRow(displayValue: value, callback: { [weak self] in
                self?.viewModel.select(division: value)
                self?.layoutWorkoutDescription()
                self?.trackFilters()
            })
        }

        let component = PickerViewComponent(displayValues: rows, selectedRow: viewModel.selectedDivision.flatMap({ (value) -> PickerViewRow? in
            return PickerViewRow(displayValue: value, callback: { [weak self] in
                self?.viewModel.select(division: value)
                self?.layoutWorkoutDescription()
                self?.trackFilters()
            })
        }))

        let builder = PickerViewBuilder(pickerViewModel: PickerViewModel(components: [component]))
        present(builder.build(), animated: true, completion: nil)
    }

    @IBAction private func selectType() {
        let rows = viewModel.workoutTypes.map { (value) -> PickerViewRow in
            return PickerViewRow(displayValue: workoutsLocalization.workoutType(value: value), callback: { [weak self] in
                self?.viewModel.select(workoutType: value)
                self?.layoutWorkoutDescription()
                self?.trackFilters()
            })
        }

        let component = PickerViewComponent(displayValues: rows, selectedRow: viewModel.selectedType.flatMap({ (value) -> PickerViewRow? in
            return PickerViewRow(displayValue: workoutsLocalization.workoutType(value: value), callback: { [weak self] in
                self?.viewModel.select(workoutType: value)
                self?.layoutWorkoutDescription()
                self?.trackFilters()
            })
        }))

        let builder = PickerViewBuilder(pickerViewModel: PickerViewModel(components: [component]))
        present(builder.build(), animated: true, completion: nil)
    }

    @IBAction func submitScore() {
        Simcoe.track(event: .openScoreSubmission,
                     withAdditionalProperties: [.id: viewModel.workout.id,
                                                .workout: viewModel.title ?? ""],
                     on: .workoutPages)

        submitScoreButton.showLoading(withColor: .white)
        viewModel.presentScoreSubmission(in: self, completion: { [weak self, weak submitScoreButton] error in
            submitScoreButton?.hideLoading()

            if error != nil {
                BannerManager.showBanner(text: GeneralLocalization().errorMessage,
                                         onTap: self?.submitScore ?? {})
            }
        })
    }

    private func trackFilters() {
        Simcoe.track(event: .workoutDetailsFilter,
                     withAdditionalProperties: [.id: viewModel.workout.id,
                                                .workout: viewModel.title ?? "",
                                                .division: viewModel.selectedDivision ?? "",
                                                .workoutType: viewModel.selectedType ?? ""],
                     on: .workoutPages)
    }

    private func showAdditionalInformation(content: NSAttributedString) {
        let workoutAdditionalInfoViewController = WorkoutAdditionalInfoBuilder(content: content).build()
        navigationController?.pushViewController(workoutAdditionalInfoViewController, animated: true)
    }

    private func equipmentButtonView(isHidden: Bool) {
        equipmentButtonView.isHidden = isHidden
        eqiupmentBottomBorderView.isHidden = isHidden
    }

    private func videoSubmissionButtonView(isHidden: Bool) {
        videoSubmissionStandardButtonView.isHidden = isHidden
        videoSubmissionBottomBorderView.isHidden = isHidden
    }

    private func workoutDescriptionView(isHidden: Bool) {
        notesView.isHidden = isHidden
        tiebreakerView.isHidden = isHidden
        tiebreakBottomBorderView.isHidden = isHidden

        if !isHidden && viewModel.tiebreak == nil {
            tiebreakerView.isHidden = true
        }
    }

    private func carouselView(isHidden: Bool) {
        carouselView.isHidden = isHidden
        carouselBottomBorderView.isHidden = isHidden
    }

    private func handleSegmentControlChange(index: Int) {
        workoutDescriptionSegmentControl.selectedSegmentIndex = index
        workoutDescriptionSegmentControl.applyStyle()
        if index == 0 {
            carouselView(isHidden: false)
            workoutDescriptionView(isHidden: true)
        } else {
            carouselView(isHidden: true)
            workoutDescriptionView(isHidden: false)
        }
    }

    private func layoutWorkoutDescription() {
        workoutDivisionLabel.text = viewModel.selectedDivision
        workoutTypeLabel.text = workoutsLocalization.workoutType(value: viewModel.selectedType ?? "")
        guard let division = viewModel.selectedDivision, let type = viewModel.selectedType else {
            return
        }
        if let attributedText = viewModel.workoutStepDescription(byDivision: division, andType: type) {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.trimCharacters(inCharSet: .whitespacesAndNewlines)
            workoutDescriptionLabel.attributedText = mutableAttributedText
        }
    }

    private func populateStackImageStackView() {
        let urls = viewModel.workoutStandardImages
        stepImageScrollView.delegate = self
        stepImageScrollView.decelerationRate = scrollViewDecelerationRate
        stepImageScrollView.showsHorizontalScrollIndicator = false

        stepNumberLabel.text = localization.step(1, outOf: viewModel.workoutStandardDescriptions.count)
        stepDescriptionLabel.text = viewModel.workoutStandardDescriptions.first

        pageControl.numberOfPages = viewModel.workoutStandardImages.count
        pageControl.dotSize = 8
        pageControl.mediumDotSizeRatio = 6 / 8
        pageControl.smallDotSizeRatio = 4 / 8
        pageControl.currentPageIndicatorTintColor = selectedDotColor
        pageControl.pageIndicatorTintColor = selectedDotColor.withAlphaComponent(deselectedDotColorOpacity)
        pageControl.dotSpace = 8
        pageControl.updateViewSize()

        for url in urls {
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .scaleAspectFit
            stepImageStackView.addArrangedSubview(imageView)
            let widthConstraint = NSLayoutConstraint(item: view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: imageView,
                                                     attribute: .width,
                                                     multiplier: 1,
                                                     constant: movementStandardSeparation)
            view.addConstraint(widthConstraint)
            imageView.download(imageURL: url)
        }
    }

}

// MARK: - UIScrollViewDelegate
extension WorkoutDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !didTrackMovementStandardSwipe {
            didTrackMovementStandardSwipe = true

            Simcoe.track(event: .workoutMovementStandards,
                         withAdditionalProperties: [.id: viewModel.workout.id,
                                                    .workout: viewModel.title ?? ""],
                         on: .workoutPages)
        }
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let proposedOffset = targetContentOffset.pointee.x

        let pagef = proposedOffset / scrollView.bounds.width
        let page = pagef.rounded()

        targetContentOffset.pointee.x = page * scrollView.bounds.width
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexf = scrollView.contentOffset.x / scrollView.contentSize.width * CGFloat(stepImageStackView.arrangedSubviews.count)
        let index = Int(round(indexf))

        stepNumberLabel.text = localization.step(index + 1, outOf: viewModel.workoutStandardDescriptions.count)
        stepDescriptionLabel.text = viewModel.workoutStandardDescriptions.dropFirst(index).first
    }

}

// MARK: - Youtube player view delgate functions
extension WorkoutDetailsViewController: YTPlayerViewDelegate {

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .ended:
            rotateScreenToPortraitMode()
        case .paused:
            rotateScreenToPortraitMode()
        case .playing where !didPlayVideo:
            didPlayVideo = true
            Simcoe.track(event: .workoutVideoExpanded,
                         withAdditionalProperties: [.id: viewModel.workout.id,
                                                    .workout: viewModel.title ?? ""],
                         on: .workoutPages)
        default:
            break
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.stopActivityIndicator()
    }
    
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let placeholderView = UIView(frame: videoPlayerView.frame)
        placeholderView.backgroundColor = UIColor(displayP3Red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        placeholderView.startActivityIndicator()
        return placeholderView
    }

    private func rotateScreenToLandscapeMode() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    }

    private func rotateScreenToPortraitMode() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
}
