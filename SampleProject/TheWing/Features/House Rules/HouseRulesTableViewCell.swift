//
//  HouseRulesTableViewCell.swift
//  TheWing
//
//  Created by Paul Jones on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class HouseRulesTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties

    private var iconImageView = UIImageView(forAutoLayout: ())
    
    private var titleLabel = UILabel(forAutoLayout: ())
    
    private var bodyLabel = UILabel(forAutoLayout: ())
    
    // MARK: - Public Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        bodyLabel.text = ""
        iconImageView.image = nil
    }
    
    func setup(theme: Theme, rule: HouseRule) {
        if iconImageView.superview == nil {
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .clear
            
            contentView.addSubview(iconImageView)
            iconImageView.constrain(with: CGSize(width: 55, height: 55))
            iconImageView.constrainToSuperview(attribute: .top, constant: 24)
            iconImageView.constrainToSuperview(attribute: .left, constant: 32)
            iconImageView.contentMode = .scaleAspectFit
            
            contentView.addSubview(titleLabel)
            titleLabel.constrain(attribute: .top, to: iconImageView, attribute: .bottom, constant: 11)
            titleLabel.constrainToSuperview(attribute: .left, constant: 32)
            titleLabel.constrainToSuperview(attribute: .right, constant: -32)
            titleLabel.constrain(attribute: .height, relatedBy: .greaterThanOrEqual, constant: 24)
            titleLabel.numberOfLines = 1
            
            contentView.addSubview(bodyLabel)
            bodyLabel.constrain(attribute: .top, to: titleLabel, attribute: .bottom, constant: 8)
            bodyLabel.constrainToSuperview(attribute: .left, constant: 32)
            bodyLabel.constrainToSuperview(attribute: .right, constant: -32)
            bodyLabel.constrainToSuperview(attribute: .bottom, constant: -24)
            bodyLabel.constrain(attribute: .height, relatedBy: .greaterThanOrEqual, constant: 24)
            bodyLabel.numberOfLines = 0
        }
        
        titleLabel.setText(rule.localizedTitle, using: theme.textStyleTheme.headline3)
        bodyLabel.setText(rule.localizedBody, using: theme.textStyleTheme.bodyLarge)
        iconImageView.image = rule.icon
    }

}
