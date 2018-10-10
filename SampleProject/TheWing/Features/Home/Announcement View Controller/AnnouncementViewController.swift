//
//  AnnouncementViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas
import SafariServices

final class AnnouncementViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: AnnouncementViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return button
    }()
    
    private lazy var navigationView: TransitioningNavigationView = {
        let navigationView = TransitioningNavigationView(theme: theme, backButton: closeButton, barButtons: [])
        return navigationView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.autoSetDimension(.height, toSize: 228)
        return imageView
    }()
    
    private lazy var descriptionView: UIView = {
        let subview = UIView()
        subview.addSubview(descriptionTextView)
        descriptionTextView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
        return subview
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.tintColor = theme.colorTheme.emphasisPrimary
        textView.isEditable = false
        descriptionTextViewHeightConstraint = textView.autoSetDimension(.height, toSize: 0)
        return textView
    }()
    
    private lazy var titleView: UIView = {
        let subView = UIView()
        subView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
        return subView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postAuthorView = PostAuthorView(theme: theme)
    
    private var descriptionTextViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadAnnouncement()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateDescriptionTextViewHeight()
    }

}

// MARK: - Private Functions
private extension AnnouncementViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero)
        view.addSubview(navigationView)
        navigationView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateHeader(imageURL: URL?) {
        if let imageURL = imageURL {
            scrollView.insertView(view: imageView)
            scrollView.insertDividerView(height: 24)
            closeButton.tintColor = theme.colorTheme.invertPrimary
            imageView.loadImage(from: imageURL)
            closeButton.setImage(#imageLiteral(resourceName: "modal_close_alpha"), for: .normal)
        } else {
            scrollView.insertDividerView(height: 108)
            closeButton.tintColor = theme.colorTheme.emphasisPrimary
            closeButton.setImage(#imageLiteral(resourceName: "modal_close"), for: .normal)
        }
    }
    
    func updateTitleIfNeeded(title: String?) {
        if let title = title {
            scrollView.insertView(view: titleView)
            scrollView.insertDividerView(height: 16)
            titleLabel.setText(title, using: theme.textStyleTheme.headline2)
        }
    }
    
    func updateAuthorInformation(author: String, time: String, imageURL: URL?) {
        if let authorImageURL = imageURL {
            postAuthorView.setImage(url: authorImageURL)
        }
        
        postAuthorView.set(name: author, time: time)
    }
    
}

// MARK: - AnnouncementViewDelegate
extension AnnouncementViewController: AnnouncementViewDelegate {
    
    func displayAnnouncement(data: AnnouncementData) {
        updateHeader(imageURL: data.imageURL)
        updateTitleIfNeeded(title: data.title)
        
        scrollView.insertView(view: postAuthorView)
        scrollView.insertDividerView(height: 24)
        scrollView.insertView(view: descriptionView)
        scrollView.insertDividerView(height: 48)

        updateAuthorInformation(author: data.author, time: data.timePosted, imageURL: data.authorImageURL)
        descriptionTextView.setText(data.description, using: theme.textStyleTheme.bodyNormal)
        updateDescriptionTextViewHeight()
    }
    
    func updateDescriptionTextViewHeight() {
        descriptionTextViewHeightConstraint?.constant = descriptionTextView.heightForFrameWidth
        view.layoutIfNeeded()
    }

}

// MARK: - UIScrollViewDelegate
extension AnnouncementViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y - imageView.bounds.maxY
        let percent = max(min((yOffset / ViewConstants.navigationBarThreshold), 1), 0)
        navigationView.transition(percent: percent)
    }
    
}

// MARK: - UITextViewDelegate
extension AnnouncementViewController: UITextViewDelegate {
    
    // We are intercepting this to push SFVC
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        let safariViewController = SFSafariViewController(url: URL)
        navigationController?.present(safariViewController, animated: true, completion: nil)
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionTextViewHeight()
    }
    
}
