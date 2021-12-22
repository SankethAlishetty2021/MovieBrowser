//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

struct SegueIdentifiers {
    static let showMovieDetailScreen = "MovieDetailViewController"
}
struct CellIdentifiers {
    static let albulCellIdentifier = "MovieCell"
}

class SearchViewController: UIViewController {
    
    let apiHanlder = Network()
    var movies:[Movie] = []
    
    // Outlets
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func goButtonTapped() {
        guard let searchTerm = searchBar.text?.trimmingCharacters(in: .whitespaces), searchTerm.count != 0 else {
            if movies.count != 0 {
                movies.removeAll()
                movieListView.reloadData()
                return
            }
            show(title: "Error", message: "Please enter a valid search term")
            return
        }
        loadMovies(searchQuery: searchTerm)
        view.endEditing(true)
    }
    
    @IBAction func loadMovies(searchQuery: String) {
        activity.startAnimating()
        apiHanlder.getMovies(request: MovieSearchRequest(query: searchQuery), callback: { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                self?.activity.stopAnimating()
                switch result {
                case .success(let result):
                    if result.results.count == 0 {
                        strongSelf.show(title: "No Results", message: "No results found for your search term")
                        return
                    }
                    strongSelf.movies = result.results
                    strongSelf.movieListView.reloadData()
                case .failure(let error):
                    strongSelf.show(title: "ERROR", message: error.localizedDescription)
                }
            }
        })
    }
}

// MARK: TableView Lifecycle Methods
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.albulCellIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        movieCell.setupCell(movie: movies[indexPath.row])
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.showMovieDetailScreen, sender: nil)
    }
}

// MARK: SearchBar Lifecycle Methods

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        goButtonTapped()
    }
}

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showMovieDetailScreen, let movieDetailsVC = segue.destination as? MovieDetailViewController {            
            if let selectedMovieIndex = movieListView.indexPathForSelectedRow {
                movieDetailsVC.movie = movies[selectedMovieIndex.row]
            }
        }
    }
}
