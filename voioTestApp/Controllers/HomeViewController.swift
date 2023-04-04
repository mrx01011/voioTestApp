//
//  HomeViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    var films = [Film]()
    var timer: Timer?
    //MARK: UI elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: "filmCell")
        return tableView
    }()
    private let searchController = UISearchController(searchResultsController: nil)
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        setupDelegates()
        setupSearchController()
        addObservers()
        fetchFilms(filmName: "Movie")
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    @objc func refreshTableView() {
        self.tableView.reloadData()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func fetchFilms(filmName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(filmName)&entity=movie&attribute=movieTerm"
        NetworkDataFetch.shared.fetchFilm(urlString: urlString) { [weak self] filmModel, error in
            guard let self else { return }
            if error == nil {
                guard let filmModel = filmModel else { return }
                self.films = filmModel.results
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
        
        let film = films[indexPath.row]
        cell.configureFilmCell(film: film)
        cell.isFavourite = UserDefaultsManager.shared.isFavouriteFilm(film)
        cell.favouritesButtonHandler = {
            if cell.isFavourite {
                UserDefaultsManager.shared.deleteFavouriteFilm(film)
                cell.isFavourite = false
            } else {
                UserDefaultsManager.shared.addFavouriteFilm(film)
                cell.isFavourite = true
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = films[indexPath.row]
        let detailFilmVC = DetailFilmViewController(film: film)
        show(detailFilmVC, sender: self)
    }
}
//MARK: - UISearchBarrDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                guard let self else { return }
                self.fetchFilms(filmName: searchText)
            })
        }
    }
}
