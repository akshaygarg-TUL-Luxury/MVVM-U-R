//
//  SearchRepoViewController.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import UIKit

final class SearchRepoViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainTableView: UITableView!
    
    var viewModel: SearchRepoViewModel!
    var router: SearchRepoRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
        setupDelegates()
        viewModel.didLoadView()
    }
    
    private func setupUIElements() {
        title = "Search Repository"
        searchBar.returnKeyType = .done
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
}

extension SearchRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.repositories[indexPath.row])
        return cell
    }
    
}

extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRepo(at: indexPath.row)
    }
}

extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let text = searchBar.text, !text.isEmpty {
            viewModel.didSearch(for: text)
        }
    }
}

extension SearchRepoViewController: SearchRepoOutput {
    func showList(with items: [Repository]) {
        mainTableView.reloadData()
    }
    
    func showView(for error: Error) {
        print("Show error view")
    }
    
    func openDetails(with item: Repository) {
        router.navigateToRepoDetails(for: item)
    }
}



