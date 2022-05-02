//
//  SearchRepo+AnalyticsEvent.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

extension AnalyticsEvent {
    
    static var didLoadSearchScreen: AnalyticsEvent {
        return .screen(name: "didLoadSearchScreen")
    }
    
    static var didSearchText: AnalyticsEvent {
        return .event(name: "didSearchText", params: [:])
    }
    
    static func openDetails(for repoName: String) -> AnalyticsEvent {
        return .event(name: "openDetails", params: ["repoName":repoName])
    }
}
