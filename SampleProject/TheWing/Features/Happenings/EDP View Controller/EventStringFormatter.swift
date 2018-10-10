//
//  EventStringFormatter.swift
//  TheWing
//
//  Created by Luna An on 5/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventStringFormatter {
    
    // MARK: - Public Functions
    
    /// Formats day and date string for an event ( Wednesday, October 1).
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted date string.
    static func formatDayDateString(_ dateString: String, timeZoneId: String?) -> String {
    
    // MARK: - Public Properties
    
        let dayNameText = formatDayString(dateString, timeZoneId: timeZoneId)
        let dateText = formatDateString(dateString, timeZoneId: timeZoneId)
        
        return (dayNameText + ", " + dateText).uppercased()
    }
    
    /// Formats day string for an event. ( e.g. Wednesday )
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted date string.
    static func formatDayString(_ dateString: String, timeZoneId: String?) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }

        guard let timeZoneId = timeZoneId?.nilIfEmpty else {
            return DateFormatter.dateString(from: date, format: DateFormatConstants.weekdayFormat)
        }
        
        return DateFormatter.dateString(from: date,
                                        format: DateFormatConstants.weekdayFormat,
                                        timeZone: TimeZone(identifier: timeZoneId) ?? .current)
    }
    
    /// Formats date string for an event. ( e.g. June 20 )
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted date string.
    static func formatDateString(_ dateString: String, timeZoneId: String?) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }

        guard let timeZoneId = timeZoneId?.nilIfEmpty else {
            return DateFormatter.dateString(from: date, format: DateFormatConstants.shortDateFormat)
        }
        
        return DateFormatter.dateString(from: date,
                                        format: DateFormatConstants.shortDateFormat,
                                        timeZone: TimeZone(identifier: timeZoneId) ?? .current)
    }
    
    /// Formats date string for an event. ( e.g. 2018-04-20 )
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted date string.
    static func formatDateStringForAnalytics(_ dateString: String) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }

        return DateFormatter.dateString(from: date, format: DateFormatConstants.dateFormatForAnalytics)
    }
    
    /// Formats time string for an event. ( e.g. 13:00:00)
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted time string.
    static func formatTimeStringForAnalytics(_ dateString: String) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }

        return DateFormatter.dateString(from: date, format: DateFormatConstants.timeFormatForAnalytics)
    }
    
    /// Formats abbreviated day string for an event.
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted date string.
    static func formatAbbreviatedDayString(_ dateString: String, timeZoneId: String?) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }
        
        guard let timeZoneId = timeZoneId?.nilIfEmpty else {
            let dayNameText = DateFormatter.dateString(from: date, format: DateFormatConstants.shortWeekdayFormat)
            let dateText = DateFormatter.dateString(from: date, format: DateFormatConstants.shortDateFormat)
            return (dayNameText + ", " + dateText).uppercased()
        }
        
        let dayNameText = DateFormatter.dateString(from: date,
                                                   format: DateFormatConstants.shortWeekdayFormat,
                                                   timeZone: TimeZone(identifier: timeZoneId) ?? .current)
        let dateText = DateFormatter.dateString(from: date,
                                                format: DateFormatConstants.shortDateFormat,
                                                timeZone: TimeZone(identifier: timeZoneId) ?? .current)
        return (dayNameText + ", " + dateText).uppercased()
    }
    
    /// Formats time duration string for an event (7:00 PM - 9:00 PM).
    ///
    /// - Parameters:
    ///   - startDateString: Start date string received from API.
    ///   - endDateString: End date string received from API.
    /// - Returns: Formatted time duration string.
    static func formatTimeDuration(startDateString: String, endDateString: String?, timeZoneId: String?) -> String {
        let startTime = formatTimeString(startDateString, timeZoneId: timeZoneId)
    
        if let dateString = endDateString, !dateString.isEmpty {
            let endTime = formatTimeString(dateString, timeZoneId: timeZoneId)
            return "\(startTime) - \(endTime)"
        }
        
        return startTime
    }
    
    /// Formats time string for an event (7:00 PM).
    ///
    /// - Parameter dateString: Data string received from API.
    /// - Returns: Formatted time string.
    static func formatTimeString(_ dateString: String, timeZoneId: String?) -> String {
        guard let date = date(for: dateString) else {
            return ""
        }
        
        guard let timeZoneId = timeZoneId?.nilIfEmpty else {
            return DateFormatter.dateString(from: date, format: DateFormatConstants.timeFormat).uppercased()
        }
        
        return DateFormatter.dateString(from: date,
                                 format: DateFormatConstants.timeFormat,
                                 timeZone: TimeZone(identifier: timeZoneId) ?? .current).uppercased()
    }
    
    /// Formats event type string for an event.
    ///
    /// - Parameter rawEventTypeString: Raw event type string received from API.
    /// - Returns: Formatted type string.
    static func formatEventType(_ rawEventTypeString: String) -> String {
        return rawEventTypeString.whitespaceTrimmed.split(separator: "_").joined(separator: " ").uppercased()
    }

    /// Date for the string provided.
    ///
    /// - Parameter dateString: Date string to convert to.
    /// - Returns: Optional date in UTC timezone.
    static func date(for dateString: String) -> Date? {
        return DateFormatter.date(from: dateString,
                                  format: DateFormatConstants.serverDateFormat,
                                  timeZone: TimeZone(abbreviation: "UTC") ?? .current)
    }
    
    /// Formats event fee for an event.
    ///
    /// - Parameter fee: Raw fee data received from API as type Double.
    /// - Returns: Formatted fee string.
    static func formatEventFee(_ fee: Double?) -> String? {
        guard let fee = fee, fee != 0 else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.numberStyle = .currency
        return formatter.string(from: fee as NSNumber)
    }
    
}
