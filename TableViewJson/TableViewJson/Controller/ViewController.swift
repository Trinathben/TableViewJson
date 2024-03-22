//
//  ViewController.swift
//  TableViewJson
//
//  Created by Trinath Vikkurthi on 3/21/24.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    let cellId = "CountryCell"
    
    @IBOutlet weak var tableVIew: UITableView!
    // Existing code...
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Palatino-Italic", size: CGFloat(18))
        label.sizeToFit()
        return label
    }()
    let searchController = UISearchController(searchResultsController: nil)
    private var refreshControl = UIRefreshControl()
    private var filteredCountries = [CountryListM]()
    var vm = CountryListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupSearchController()
        fetchCountries()
    }
}
//Setup
extension ViewController {
    
    private func tableViewSetup() {
        tableVIew.dataSource = self
        let nib = UINib(nibName: cellId, bundle: nil)
        tableVIew.register(nib, forCellReuseIdentifier: cellId)
        // Add refresh control to table view
        refreshControl.addTarget(self, action: #selector(fetchCountries), for: .valueChanged)
        tableVIew.addSubview(refreshControl)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//API Calling..
extension ViewController {
    
    @objc private func fetchCountries() {
        let connectionMode = try? Reachability().connection
        switch connectionMode {
        case .cellular, .wifi:
            self.showErrorLabel(with: "Fetching..")
            self.vm.fetchCountries {
                if $0.count == 0 {
                    self.showErrorLabel(with: "Failed to fetch data. Please try again later.")
                } else {
                    // Hide error label if data is successfully fetched
                    self.hideErrorLabel()
                    self.tableVIew.reloadData()
                }
                self.refreshControl.endRefreshing()
            }
        case .some(.unavailable), .none:
            self.showNetworkError()
        }
    }
}
//TableView Data Source & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterActive() ? filteredCountries.count : self.vm.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        if isFilterActive() {
            cell.setupData(model: filteredCountries[indexPath.row], query: searchController.searchBar.text ?? "")
        } else {
            cell.setupData(model: self.vm.countries[indexPath.row], query: "")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//Private Methods
extension ViewController {
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCountries = self.vm.countries.filter { country in
            return country.name.lowercased().contains(searchText.lowercased()) ||
            country.capital.lowercased().contains(searchText.lowercased())
        }
        if filteredCountries.count == 0 {
            self.showErrorLabel(with: "Opps..\n Country not found!")
        } else {
            self.hideErrorLabel()
        }
        tableVIew.reloadData()
    }
    
    private func isFilterActive() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

//Search bar delegate
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableVIew.reloadData()
    }
}

//Hide & show
extension ViewController {
    func hideErrorLabel() {
        tableVIew.backgroundView = nil
        tableVIew.separatorStyle = .singleLine
    }
    func showErrorLabel(with message: String) {
        errorLabel.text = message
        errorLabel.frame = tableVIew.bounds
        tableVIew.backgroundView = errorLabel
        tableVIew.separatorStyle = .none
    }
}
