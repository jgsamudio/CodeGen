//
//  UIViewExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: - Public Functions
    
    /// Returns a blank view to be used as a divider in stack views.
    ///
    /// - Parameters:
    ///   - width: Width.
    ///   - height: Height.
    ///   - color: Background color.
    /// - Returns: UIView.
    static func dividerView(width: CGFloat? = nil,
                            height: CGFloat? = nil,
                            color: UIColor = UIColor.clear,
                            priority: UILayoutPriority = .required) -> UIView {
    
    // MARK: - Public Properties
    
        let divider = UIView()
        divider.backgroundColor = color
        
        NSLayoutConstraint.autoSetPriority(priority) {
            if let height = height {
                divider.autoSetDimension(.height, toSize: height)
            }
            
            if let width = width {
                divider.autoSetDimension(.width, toSize: width)
            }
        }
        
        return divider
    }

    /// Returns height of view if given fixed width.
    ///
    /// - Parameter width: Width.
    /// - Returns: Height.
    func heightForWidth(_ width: CGFloat) -> CGFloat {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    /// Calculate the height given the current frame width
    var heightForFrameWidth: CGFloat {
        return heightForWidth(frame.width)
    }
    
    /// Adds a divider view with the given parameters.
    ///
    /// - Parameters:
    ///   - height: Height of the divder view.
    ///   - leadingOffset: Leading offset of the divider view.
    ///   - color: Color of the divider view.
    func addDividerView(height: CGFloat = 1, leadingOffset: CGFloat = 0, color: UIColor) {
        let dividerView = UIView()
        dividerView.backgroundColor = color
        addSubview(dividerView)
        dividerView.autoSetDimension(.height, toSize: height)
        dividerView.autoPinEdge(.bottom, to: .bottom, of: self)
        dividerView.autoPinEdge(.leading, to: .leading, of: self, withOffset: leadingOffset)
        dividerView.autoPinEdge(.trailing, to: .trailing, of: self)
    }

    /// Removes all gesture recognizers.
    func removeGestureRecognizers() {
        guard let gestureRecognizers = gestureRecognizers else {
            return
        }
        for gestureRocognizer in gestureRecognizers {
            removeGestureRecognizer(gestureRocognizer)
        }
    }
    
    /// Make the view look circular.
    func updateCornerRadiusForCircularMask() {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 0
    }
    
    /// Make the view square.
    func autoMatchHeightAndWidthForSquareFrame() {
        autoMatch(.height, to: .width, of: self)
    }
    
    /// Set an aspect ratio to the view.
    ///
    /// - Parameters:
    ///   - height: height aspect ratio
    ///   - width: width aspect ratio
    func autoMatchAspectRatio(withHeight height: CGFloat, andWidth width: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: height / width,
                                         constant: 0))
    }
    
    /// Animates each keyframe equally over the course of the duration.
    ///
    /// If you pass in 10 animations and a duration of 10 seconds, the first animation will be delayed 0/10s and run 1/10s,
    /// the second will be delay 1/10s and run 1/10s, …, the nth will be delayed n/10 and run 1/10 until 9/10 lasting 1/10
    /// seconds.
    ///
    /// If you pass 5 animations and a duration of 10 seconds, the first animation will be delayed 0/5s and run 1/5s,
    /// the second will be delay 1/5s and run 1/10s, …, the nth will be delayed n/5 and run 1/5 until 4/5 lasting 1/5
    /// seconds.
    ///
    /// So it’s useful for saying “this group of animations will run 2 seconds and there are 5 different things I want you
    /// to do one after the other, work out how to schedule them and how long they last because that’s hard work I don’t
    /// want to think about.”
    ///
    ///  0   1               5                  10
    ///  |---|---|---|---|---|---|---|---|---|---|
    ///  111111111
    ///          222222222
    ///                  333333333
    ///                          444444444
    ///                                  555555555
    ///
    /// - Parameters:
    ///   - duration: How long for the whole animation?
    ///   - delay: How long to wait until starting the animation?
    ///   - options: See options documentation in UIKit
    ///   - keyframes: An array of animation closures, length determines duration of each animation (1/n)
    ///   - completion: See completion documentation in UIKit.
    class func animateKeyframes(withTotalDuration duration: TimeInterval,
                                delay: TimeInterval = 0,
                                options: UIViewKeyframeAnimationOptions = [],
                                keyframes: [() -> Void],
                                completion: ((Bool) -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
            var animationIndex: TimeInterval = 0
            keyframes.forEach {
                UIView.addKeyframe(withRelativeStartTime: animationIndex / TimeInterval(keyframes.count),
                                   relativeDuration: 1 / duration,
                                   animations: $0)
                animationIndex += 1
            }
        }, completion: completion)
    }
    
    /// Use this to do the same thing as `animateKeyframes(withTotalDuration:)`, but instead of specifying
    /// a total duration for each animation to share and divide between them, you can specify the duration
    /// of _each_ animation, meaning that the first will last the duration, the second will last the duration,
    /// etc, and the total duration will equal the duration multiplied by the number of keyframes.
    ///
    /// - Parameters:
    ///   - duration: the length of each animation
    ///   - delay: How long to wait until starting the animation?
    ///   - options: See options documentation in UIKit
    ///   - keyframes: An array of animation closures, length determines duration of each animation (1/n)
    ///   - completion: See completion documentation in UIKit.
    class func animateKeyframes(eachWithDuration duration: TimeInterval,
                                delay: TimeInterval = 0,
                                options: UIViewKeyframeAnimationOptions = [],
                                keyframes: [() -> Void],
                                completion: ((Bool) -> Void)? = nil) {
        let keyframeCount = TimeInterval(keyframes.count)
        UIView.animateKeyframes(withDuration: duration * keyframeCount, delay: delay, options: [], animations: {
            var animationIndex: TimeInterval = 0
            keyframes.forEach {
                UIView.addKeyframe(withRelativeStartTime: animationIndex / keyframeCount,
                                   relativeDuration: duration,
                                   animations: $0)
                animationIndex += 1
            }
        }, completion: completion)
    }

    /// Constrain this view to another view on a single attribute.
    ///
    /// - Parameters:
    ///   - item: The other view
    ///   - sharedAttribute: The attribute you want these views to share
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute, "offset".
    /// - Returns: The layout constraint, not usually needed.
    @objc @discardableResult func constrain(to item: UIView? = nil,
                                            attribute sharedAttribute: NSLayoutAttribute,
                                            relatedBy relation: NSLayoutRelation = .equal,
                                            multiplier: CGFloat = 1,
                                            constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self,
                                  attribute: sharedAttribute,
                                  relatedBy: relation,
                                  toItem: item,
                                  multiplier: multiplier,
                                  constant: constant,
                                  isActive: true)
    }
    
    /// Constrain this view's attribute to another view's attribute
    ///
    /// - Parameters:
    ///   - attr1: Your view's attribute
    ///   - item: The other view
    ///   - attr2: The other view's attribute
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute, "offset".
    /// - Returns: The layout constraint, not usually needed.
    @objc @discardableResult func constrain(attribute attr1: NSLayoutAttribute,
                                            to item: UIView,
                                            attribute attr2: NSLayoutAttribute,
                                            relatedBy relation: NSLayoutRelation = .equal,
                                            multiplier: CGFloat = 1,
                                            constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self,
                                  attribute: attr1,
                                  relatedBy: relation,
                                  toItem: item,
                                  attribute: attr2,
                                  multiplier: multiplier,
                                  constant: constant,
                                  isActive: true)
    }
    
    /// Constrain to superview's shared attribute
    ///
    /// - Parameters:
    ///   - sharedAttribute: The shared attribute
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute, "offset".
    /// - Returns: The constraint, not usually needed, if superview exists
    @objc @discardableResult func constrainToSuperview(attribute sharedAttribute: NSLayoutAttribute,
                                                       relatedBy relation: NSLayoutRelation = .equal,
                                                       multiplier: CGFloat = 1,
                                                       constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return constrain(to: superview,
                         attribute: sharedAttribute,
                         relatedBy: relation,
                         multiplier: multiplier,
                         constant: constant)
    }
    
    /// Constrain to a superview's attribute
    ///
    /// - Parameters:
    ///   - attr1: Your attribute
    ///   - relation: The relation that attribute should have
    ///   - attr2: The superview's attribute
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute, "offset".
    /// - Returns: The constraint, not usually needed, if superview exists
    @objc @discardableResult func constrainToSuperviews(attribute attr1: NSLayoutAttribute,
                                                        relatedBy relation: NSLayoutRelation = .equal,
                                                        toAttribute attr2: NSLayoutAttribute,
                                                        multiplier: CGFloat = 1,
                                                        constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return constrain(attribute: attr2,
                         to: superview,
                         attribute: attr1,
                         relatedBy: relation,
                         multiplier: multiplier,
                         constant: constant)
    }
    
    /// Constraint to shared attributes, creating multiple constraints.
    ///
    /// - Parameters:
    ///   - item: The view to constrain to
    ///   - sharedAttributes: The attributes you want these views to share.
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute, "offset".
    /// - Returns: The constraints, not usually needed
    @discardableResult func constrain(to item: UIView,
                                      attributes sharedAttributes: [NSLayoutAttribute],
                                      relatedBy relation: NSLayoutRelation = .equal,
                                      multiplier: CGFloat = 1,
                                      constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return sharedAttributes.map({ constrain(to: item,
                                                attribute: $0,
                                                relatedBy: relation,
                                                multiplier: multiplier,
                                                constant: constant) })
    }
    
    /// Constrain to an item using edge insets, a convienience.
    ///
    /// - Parameters:
    ///   - item: The item to constrain to
    ///   - edgeInsets: The edge insets you want to use to build constraints
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - margin: To the margin or not?
    /// - Returns: The constraints, not usually needed
    @objc @discardableResult func constrain(to item: UIView,
                                            edgeInsets: UIEdgeInsets = .zero,
                                            relatedBy relation: NSLayoutRelation = .equal,
                                            multiplier: CGFloat = 1,
                                            margin: Bool = false) -> [NSLayoutConstraint] {
        return [constrain(to: item,
                          attribute: margin ? .topMargin : .top,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: edgeInsets.top),
                constrain(to: item,
                          attribute: margin ? .leftMargin : .left,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: edgeInsets.left),
                constrain(to: item,
                          attribute: margin ? .rightMargin : .right,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: -edgeInsets.right),
                constrain(to: item,
                          attribute: margin ? .bottomMargin : .bottom,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: -edgeInsets.bottom)]
    }
    
    /// Constrain to superview using edge insets, a convienience.
    ///
    /// - Parameters:
    ///   - edgeInsets: The edge insets you want the subview to have.
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - margin: To the margin or not?
    /// - Returns: The constraints, not usually needed
    @objc @discardableResult func constrainToSuperview(edgeInsets: UIEdgeInsets = .zero,
                                                       relatedBy relation: NSLayoutRelation = .equal,
                                                       multiplier: CGFloat = 1,
                                                       margin: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [constrain(to: superview,
                          attribute: margin ? .topMargin : .top,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: edgeInsets.top),
                constrain(to: superview,
                          attribute: margin ? .leftMargin : .left,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: edgeInsets.left),
                constrain(to: superview,
                          attribute: margin ? .rightMargin : .right,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: -edgeInsets.right),
                constrain(to: superview,
                          attribute: margin ? .bottomMargin : .bottom,
                          relatedBy: relation,
                          multiplier: multiplier,
                          constant: -edgeInsets.bottom)]
    }
    
    /// Constrain to multiple attributes on the superview
    ///
    /// - Parameters:
    ///   - attributes: The attributes you want these views to share
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    ///   - constant: The constant for the attribute
    /// - Returns: The constraints, not usually needed
    @discardableResult func constrainToSuperview(attributes: [NSLayoutAttribute],
                                                 relatedBy relation: NSLayoutRelation = .equal,
                                                 multiplier: CGFloat = 1,
                                                 constant: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return constrain(to: superview,
                         attributes: attributes,
                         relatedBy: relation,
                         multiplier: multiplier,
                         constant: constant)
    }
    
    /// A convienice that allows you to size a view with constraints using CGSize
    ///
    /// - Parameters:
    ///   - size: The size you want
    ///   - relation: The relation that attribute should have
    ///   - multiplier: The multiplier for the attribute
    /// - Returns: The constraint, not usually needed
    @objc @discardableResult func constrain(with size: CGSize,
                                            relatedBy relation: NSLayoutRelation = .equal,
                                            multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        return [constrain(attribute: .height, relatedBy: relation, multiplier: multiplier, constant: size.height),
                constrain(attribute: .width, relatedBy: relation, multiplier: multiplier, constant: size.width)]
    }

}
