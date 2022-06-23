//
//  AnalyticsEvent.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

enum AnalyticsEvent: Equatable {
    case screen(name: String)
    case event(name: String, params: [String: AnyHashable])
}
