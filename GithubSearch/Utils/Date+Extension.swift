//
//  Date+Extension.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
