//
//  CardDetailContainerViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller that contains and manages proper scrolling of titles alongside view controllers for those titles.
final class CardDetailContainerViewController: BaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var viewControllerStack: UIStackView!

    @IBOutlet private weak var titleViewStack: UIStackView!

    var viewModel: CardDetailContainerViewModel!

    /// View controllers shown within the horizontal scroll view.
    var presentedViewControllers: [UIViewController] {
        return childViewControllers
    }

    private var didViewAppear = false

    private var titleObservations: [Any] = []

    deinit {
        // Avoids crash in iOS 10 when observers are still active on the presented child view controllers.
        titleObservations.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        viewModel.viewControllers.enumerated().forEach { (item) in
            setup(childViewController: item.element, title: item.element.title ?? "", index: item.offset)
        }
        updateTitles()
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
        layoutTitles(withScrollView: scrollView)
        scrollView.contentOffset.x = CGFloat(viewModel.initialViewIndex) * view.bounds.width
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didViewAppear = true

        animateScroll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.initialViewIndex = Int(round(scrollView.contentOffset.x / view.bounds.width))
    }

    /// Update the titles of view controllers shown within `self`.
    func updateTitles() {
        viewModel.viewControllers.enumerated().forEach { (item) in
            (titleViewStack.arrangedSubviews[item.offset] as? CardDetailContainerTab)?.title = item.element.title
            titleViewStack.layoutIfNeeded()
        }
    }

    private func setup(childViewController: UIViewController, title: String, index: Int) {
        let titleObservation = childViewController.observe(\.title) { [weak self] (viewController, _) in
            (self?.titleViewStack.arrangedSubviews[index] as? CardDetailContainerTab)?.title = viewController.title
        }
        titleObservations.append(titleObservation)
        addChildViewController(childViewController)
        guard let childView = childViewController.view else {
            return
        }

        guard let tab = UINib(nibName: String(describing: CardDetailContainerTab.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? CardDetailContainerTab else {
                return
        }
        tab.title = title

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tab.addGestureRecognizer(gestureRecognizer)

        viewControllerStack.insertArrangedSubview(childView, at: index)
        titleViewStack.insertArrangedSubview(tab, at: index)

        let labelWidthConstraint = NSLayoutConstraint(item: tab,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .width,
                                                      multiplier: 0.57,
                                                      constant: 0)

        let subViewWidthConstraint = NSLayoutConstraint(item: childView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .width,
                                                 multiplier: 1.0,
                                                 constant: 0)

        NSLayoutConstraint.activate([
            labelWidthConstraint,
            subViewWidthConstraint
        ])
    }

    @objc private func didTap(_ recognizer: UIGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }

        guard let viewIndex = titleViewStack.arrangedSubviews.index(of: view) else {
            return
        }

        scrollView.setContentOffset(CGPoint(x: CGFloat(viewIndex) * scrollView.bounds.width,
                                            y: scrollView.contentOffset.y),
                                    animated: true)
    }

}

// MARK: - UIScrollViewDelegate
extension CardDetailContainerViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutTitles(withScrollView: scrollView)
        animateScroll()
    }

    private func animateScroll() {
        guard didViewAppear else {
            return
        }

        childViewControllers.forEach { (viewController) in
            guard let delegate = viewController as? UIViewController & CardDetailContainerDelegate else {
                return
            }

            let point = delegate.view.convert(CGPoint.zero, to: view)
            let visibility = 1 - abs(point.x) / view.bounds.width

            if visibility > 0.9 {
                (viewController as? DashboardStatsViewController)?.loadDataIfNeeded()
                delegate.container(self, changedVisibility: 1)
            }
        }
    }

    private func layoutTitles(withScrollView scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let titleViewWidths = titleViewStack.arrangedSubviews.map { $0.bounds.width }
        titleViewStack.transform = CGAffineTransform(translationX: titleOffset(page: page,
                                                                               viewWidth: scrollView.bounds.width,
                                                                               titleViewWidths: titleViewWidths,
                                                                               spacing: titleViewStack.spacing), y: 0)
        adjustTabAlpha(page: page)
    }

    private func adjustTabAlpha(page: CGFloat) {
        titleViewStack.arrangedSubviews.enumerated().forEach { (offset, element) in
            guard let element = element as? CardDetailContainerTab else {
                return
            }

            element.contentAlpha = 1 - min(abs(page - CGFloat(offset)), 1)
        }
    }

    /// Computes the translation that has to be applied to the title stack view in order to center the right title
    /// above its matching view controller.
    ///
    /// - Parameters:
    ///   - page: Current Page (0 being first view controller)
    ///   - viewWidth: Width of the super view.
    ///   - titleViewWidths: Widths of all title views.
    ///   - spacing: Constant spacing added to each view controller as part of the stack view.
    private func titleOffset(page: CGFloat, viewWidth: CGFloat, titleViewWidths: [CGFloat], spacing: CGFloat) -> CGFloat {
        let initialOffset = page * viewWidth
        let arraySafeIndex = max(min(Int(round(page)), titleViewWidths.count - 1), 0)
        let withinScreenOffset = (viewWidth - titleViewWidths[arraySafeIndex]) * 0.5
        let passedDistance = arraySafeIndex == 0
            ? CGFloat(0)
            : ((0..<(arraySafeIndex)).map { titleViewWidths[$0] }.reduce(CGFloat(0), +) + CGFloat(arraySafeIndex) * spacing)
        let continuousScrollAdjustment = (CGFloat(arraySafeIndex) - page) * (titleViewWidths[arraySafeIndex] + spacing)

        return initialOffset + withinScreenOffset - passedDistance + continuousScrollAdjustment
    }

}
