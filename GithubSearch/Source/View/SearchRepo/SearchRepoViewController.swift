//
//  SearchRepoViewController.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Combine
import UIKit

final class SearchRepoViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainTableView: UITableView!
    
    var viewModel: SearchRepoViewModel!
    var router: SearchRepoRouter!
    private var cancellable = Set<AnyCancellable>()
    private var dataSource: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
        setupDelegates()
        bindViewModel()
        
        viewModel.input.didLoadView.send(())
        
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
    
    // publisher -> operations -> observer(sink) -> AnyCancellable
    private func bindViewModel() {
        let output = viewModel.transform()
        
        output.repositories
            .sink { [unowned self] repositories in
                self.dataSource = repositories
                self.mainTableView.reloadData()
            }
            .store(in: &cancellable)
        
        
        output.error
            .sink { error in
                print("===> \(error.localizedDescription)")
            }
            .store(in: &cancellable)
        
        output.openDetails
            .sink {[unowned self] repository in
                self.router.navigateToRepoDetails(for: repository)
            }
            .store(in: &cancellable)
        
    }
    
    deinit {
        print("deinit : \(self)")
    }
}

extension SearchRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else {
            return UITableViewCell()
        }
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
    
}

extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.didSelectRepo.send(indexPath.row)
    }
}

extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let text = searchBar.text, !text.isEmpty {
            viewModel.input.didSearch.send(text)
        }
    }
}



