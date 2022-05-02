//
//  UIViewController+Extension.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiateViewController() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name Main")
        }
        return vc
    }
}
