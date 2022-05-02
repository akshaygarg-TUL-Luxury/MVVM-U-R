//
//  RepoDetailsViewController.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import UIKit

final class RepoDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: RepoDetailsViewModel!
    var router: RepoDetailsRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDetails()
        descriptionLabel.numberOfLines = 0
        viewModel.didLoadView()
    }
    
    @IBAction func urlButtonTapped(_ sender: UIButton) {
        viewModel.didTapUrl()
    }
    
    func showDetails() {
        title = viewModel.repository.name
        nameLabel.text = viewModel.repository.full_name
        dateLabel.text = viewModel.repository.created_at.formattedDate
        watchersLabel.text = "\(viewModel.repository.watchers)"
        urlButton.setTitle(viewModel.repository.html_url.absoluteString, for: .normal)
        descriptionLabel.text = viewModel.repository.description
    }
}

extension RepoDetailsViewController: RepoDetailsOutput {
    func open(url: URL) {
        router.open(url: url)
    }
}
