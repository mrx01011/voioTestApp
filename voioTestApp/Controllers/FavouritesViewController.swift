//
//  FavouritesViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class FavouritesViewController: UIViewController {
    private var favouriteFilms = [Film]()
    //MARK: UI elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: "favouriteFilmCell")
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        setupDelegates()
        fetchFavouritesFilms()
        addObservers()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    @objc func refresh() {
        fetchFavouritesFilms()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
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
    }
    
    private func fetchFavouritesFilms() {
        if let favourites = UserDefaultsManager.shared.activeUser?.favouritesFilms {
            favouriteFilms = favourites
        }
        tableView.reloadData()
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteFilmCell", for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
        let film = favouriteFilms[indexPath.row]
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
            self.fetchFavouritesFilms()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = favouriteFilms[indexPath.row]
        let detailFilmVC = DetailFilmViewController(film: film)
        show(detailFilmVC, sender: self)
    }
}
