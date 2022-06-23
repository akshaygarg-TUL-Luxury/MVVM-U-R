//
//  InitialViewController.swift
//  GithubSearch
//
//  Created by Akshay Garg on 12/05/22.
//

import UIKit

class InitialViewController: UIViewController {
    
    var router: InitialViewRouter!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        router.navigateToSearchPage()
    }
}
