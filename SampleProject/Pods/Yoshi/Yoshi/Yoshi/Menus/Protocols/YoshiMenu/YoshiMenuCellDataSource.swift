//
//  YoshiMenuCellDataSource.swift
//  Yoshi
//
//  Created by Kanglei Fang on 24/02/2017.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

/// A normal cell data source defining the layout for YoshiMenu's cell.
/// By default it helps dequeue a system UITableViewCell with the given title, subtitle and the accessoryType.
public struct YoshiMenuCellDataSource: YoshiReusableCellDataSource {

    // MARK: - Private Properties
    
    private let title: String

    private let subtitle: String?

    private let accessoryType: UITableViewCellAccessoryType

    // MARK: - Initialization
    
    /// Initalize the YoshiMenuCellDataSource instance
    ///
    /// - Parameters:
    ///   - title: Main title for the cell
    ///   - subtitle: Subtitle for the cell
    public init(title: String, subtitle: String?, accessoryType: UITableViewCellAccessoryType = .none) {
        self.title = title
        self.subtitle = subtitle
        self.accessoryType = accessoryType
    }

    // MARK: - Public Functions
    
    public func cellFor(tableView: UITableView) -> UITableViewCell {
    
    // MARK: - Public Properties
    
        let cell = tableView.dequeueReusableCell(withIdentifier: YoshiMenuCellDataSource.reuseIdentifier) ??
            UITableViewCell(style: .subtitle, reuseIdentifier: YoshiMenuCellDataSource.reuseIdentifier)

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle

        cell.accessoryType = accessoryType

        return cell
    }
}
