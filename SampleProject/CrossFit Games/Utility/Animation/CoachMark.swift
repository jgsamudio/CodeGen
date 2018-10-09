//
//  CoachMark.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Lottie

/// Coach mark to prompt users to tap on something.
final class CoachMark: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        isUserInteractionEnabled = false
        setupLabel()
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .init(width: 1, height: 2)
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = max(bounds.width, bounds.height) / 2
    }

    /// Plays the animation.
    func play() {
        UIView.animateKeyframes(withDuration: 2.2, delay: 0, options: UIViewKeyframeAnimationOptions.repeat, animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 2.2) {
                self?.grow()
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 2.2, relativeDuration: 0.3 / 2.2) {
                self?.shrink()
            }
        }, completion: nil)
    }

    private func setupLabel() {
        let label = StyleableLabel(frame: bounds)
        label.text = DashboardLocalization().tap
        label.textAlignment = .center
        label.row = 4
        label.column = 2
        label.weight = 2
        addSubview(label)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: label,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: label,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
    }

    @objc private func grow() {
        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        alpha = 0.75
    }

    @objc private func shrink() {
        transform = .identity
        alpha = 1
    }

}
