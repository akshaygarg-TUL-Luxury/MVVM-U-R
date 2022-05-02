//
//  RepoDetails+AnalyticsEvent.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

extension AnalyticsEvent {
    
    static var didLoadRepoDetailsScreen: AnalyticsEvent {
        return .screen(name: "didLoadRepoDetailsScreen")
    }
    
    static func openURL(url: String) -> AnalyticsEvent {
        return .event(name: "openURL", params: ["url":url])
    }
}
