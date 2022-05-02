//
//  AnalyticsManager.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

protocol AnalyticsManager {
    func track(event: AnalyticsEvent)
}

final class DefaultAnalyticsManager: AnalyticsManager {
    static let shared = DefaultAnalyticsManager()
    private init() {}
    
    func track(event: AnalyticsEvent) {
        NSLog("Logged -> \(event)")
    }
}
