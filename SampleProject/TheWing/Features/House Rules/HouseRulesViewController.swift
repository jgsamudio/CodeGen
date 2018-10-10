//
//  HouseRulesViewController.swift
//  TheWing
//
//  Created by Paul Jones on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class HouseRulesViewController: BuildableViewController {

    // MARK: - Private Properties

    private lazy var tableView = UITableView(forAutoLayout: ())
    
    private lazy var titleLabel = UILabel(forAutoLayout: ())
    
    private lazy var backButton = UIButton(forAutoLayout: ())
    
    private lazy var topView = UIView(forAutoLayout: ())

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(cellClass: HouseRulesTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = colorTheme.invertPrimary
        tableView.constrainToSuperview(edgeInsets: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        
        view.addSubview(topView)
        topView.backgroundColor = colorTheme.invertPrimary
        topView.layer.shadowColor = theme.colorTheme.emphasisQuintary.cgColor
        topView.layer.shadowOffset = ViewConstants.navigationBarShadowOffset
        topView.layer.shadowRadius = ViewConstants.navigationBarShadowRadius
        topView.layer.shadowOpacity = 1
        topView.layer.masksToBounds = false
        topView.constrain(attribute: .height, constant: 100)
        topView.constrainToSuperview(attributes: [.top, .left, .right])
        
        view.addSubview(titleLabel)
        titleLabel.setText(HouseRulesLocalization.title.localized, using: textStyleTheme.headline3)
        titleLabel.constrainToSuperview(attribute: .centerX)
        titleLabel.constrainToSuperview(attribute: .top, constant: 54)
        
        view.addSubview(backButton)
        backButton.constrain(with: CGSize(width: 44, height: 44))
        backButton.constrainToSuperview(attribute: .left, constant: 15)
        backButton.constrainToSuperview(attribute: .top, constant: 44)
        backButton.setImage(#imageLiteral(resourceName: "black_back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

}

// MARK: - Private Functions
private extension HouseRulesViewController {
    
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension HouseRulesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseRule.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rule = HouseRule(rawValue: indexPath.row) {
    
    // MARK: - Public Properties
    
            let cell: HouseRulesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup(theme: theme, rule: rule)
            return cell
        } else {
            assert(false)
            return UITableViewCell()
        }
    }
    
}

// MARK: - UITableViewDelegate
extension HouseRulesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - UIScrollViewDelegate
extension HouseRulesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}
