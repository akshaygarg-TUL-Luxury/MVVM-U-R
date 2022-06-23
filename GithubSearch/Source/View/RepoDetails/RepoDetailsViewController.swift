//
//  RepoDetailsViewController.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Combine
import UIKit

final class RepoDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: RepoDetailsViewModel!
    var router: RepoDetailsRouter!
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionLabel.numberOfLines = 0
        bindViewModel()
        
        viewModel.input.didLoadView.send(())
    }
    
    @IBAction func urlButtonTapped(_ sender: UIButton) {
        viewModel.input.didTapUrl.send(())
    }
    
    private func showDetails(for repository: User) {
        self.title = repository.name
        nameLabel.text = repository.name
        dateLabel.text = repository.name
        watchersLabel.text = "\(repository.name)"
        urlButton.setTitle(repository.name, for: .normal)
        descriptionLabel.text = repository.email
    }
    
    func bindViewModel() {
        viewModel.output.showDetails
            .sink { [unowned self] repo in
                self.showDetails(for: repo)
            }
            .store(in: &cancellable)
        
        viewModel.output.openURL
            .sink { [unowned self] url in
                self.router.open(url: url)
            }
            .store(in: &cancellable)
    }
    
    deinit {
        print("deinit : \(self)")
    }
}
