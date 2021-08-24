//
//  Constants.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 24/8/21.
//

import Foundation

class Constants {
    
    static var currentTime = Date()
    static var currentTimeString = ""
    
    // Timeintervals are typealias of Doubles:
    static let dayInSeconds = 86400.00
    static let farWarning = 80000.00
    static let mediumWarning = 40000.00
    static let closeWarning = 20000.00
    static let closestWarning = 5000.00

    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        Constants.currentTimeString = dateFormatter.string(from: Constants.currentTime)
    }

}

// WIP trying via extending Date()
extension Date {
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        return ""
    }
}

