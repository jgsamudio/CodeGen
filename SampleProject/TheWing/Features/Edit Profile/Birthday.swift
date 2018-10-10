//
//  Birthday.swift
//  TheWing
//
//  Created by Luna An on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Birthday.
struct Birthday {
    
    // MARK: - Public Properties
    
    /// Birthday month.
    var month: Int
    
    /// Birthday day.
    var day: Int
    
    /// Returns a date.
    var dateUsingLeapYear: Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2016 // Default year to get days in leap years
        dateComponents.month = month
        dateComponents.day = day
        
        return calendar.date(from: dateComponents)
    }

    /// Returns an associated star sign.
    var starSign: StarSign {
        switch month {
        case 1:
            if day >= 21 {
                return .aquarius
            } else {
                return .capricorn
            }
        case 2:
            if day >= 20 {
                return .pisces
            } else {
                return .aquarius
            }
        case 3:
            if day >= 21 {
                return .aries
            } else {
                return .pisces
            }
        case 4:
            if day >= 21 {
                return .taurus
            } else {
                return .aries
            }
        case 5:
            if day >= 22 {
                return .gemini
            } else {
                return .taurus
            }
        case 6:
            if day >= 22 {
                return .cancer
            } else {
                return .gemini
            }
        case 7:
            if day >= 23 {
                return .leo
            } else {
                return .cancer
            }
        case 8:
            if day >= 23 {
                return .virgo
            } else {
                return .leo
            }
        case 9:
            if day >= 24 {
                return .libra
            } else {
                return .virgo
            }
        case 10:
            if day >= 24 {
                return .scorpio
            } else {
                return .libra
            }
        case 11:
            if day >= 23 {
                return .sagittarius
            } else {
                return .scorpio
            }
        case 12:
            if day >= 22 {
                return .capricorn
            } else {
                return .sagittarius
            }
        default:
            return .none
        }
    }
    
    /// Formatted birthday string. ( e.g. June 20 )
    var formattedBirthdayString: String {
        guard let date = dateUsingLeapYear else {
            return ""
        }
        
        return DateFormatter.dateString(from: date, format: DateFormatConstants.shortDateFormat)
    }
    
    /// Formats birthday to post to API. (e.g. "MM-DD")
    var encodedBirthday: String {
        if month == 0 || day == 0 {
            return ""
        }
        let formattedMonth = String(format: "%02d", month)
        let formattedDay = String(format: "%02d", day)
        
        return "\(formattedMonth)-\(formattedDay)"
    }
    
    // MARK: - Public Functions
    
    /// Decodes birthday raw string received from API.
    ///
    /// - Parameter birthday: Birthday string to decode.
    /// - Returns: Birthday.
    static func decodeBirthday(birthday: String?) -> Birthday? {
        guard let birthday = birthday else {
            return nil
        }
        
        let birthdayArray = birthday.components(separatedBy: "-")
        if birthdayArray.count == 2 {
            if let month = Int(birthdayArray[0]), let day = Int(birthdayArray[1]) {
                if month == 0 || day == 0 {
                    return nil
                }
                return Birthday(month: month, day: day)
            }
        }
        return nil
    }

}
