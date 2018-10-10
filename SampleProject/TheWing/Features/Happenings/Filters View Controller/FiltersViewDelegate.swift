//
//  FiltersViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol FiltersViewDelegate: ErrorDelegate {

    /// Displays the filter sections.
    ///
    /// - Parameter sections: Filter sections.
    func displaySections(_ sections: FilterSections)
    
    /// Displays results count information.
    ///
    /// - Parameter resultsCountInfo: Results count information string.
    func displayResultsCount(_ resultsCountInfo: String)

    /// Displays alert given a title and message.
    ///
    /// - Parameters:
    ///   - title: Title.
    ///   - message: Message.
    func displayAlert(title: String, message: String)
    
    /// Updates section with new tags and data sources.
    ///
    /// - Parameters:
    ///   - section: Section key.
    ///   - dataSources: Tuple of tags array and array of data sources.
    func updateSection(_ section: String, dataSources: PillDataSources)
    
    /// Close action.
    func dismissAction()
    
    /// Loading action.
    ///
    /// - Parameter loading: If true, notifies delegate view is loading, false otherwise.
    func isLoading(loading: Bool)
    
    /// Sets the enabled property of the removed all action.
    ///
    /// - Parameter enabled: True, if enabled, false otherwise.
    func setRemoveAllEnabled(_ enabled: Bool)
    
}
