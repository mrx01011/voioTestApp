//
//  FilmTableViewCell.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class FilmTableViewCell: UITableViewCell {
    var favouritesButtonHandler: (() -> Void)?
    var isFavourite = false {
                didSet {
                    let image = isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                    favouriteButton.setImage(image, for: .normal)
                }
            }
    //MARK: UI elements
    private let filmNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Film name"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private let filmYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    private let filmGenreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genre"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    private let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        return button
    }()
    private let filmLogo = UIImageView()
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defaultConfigurations()
        setupUI()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Methods
    func configureFilmCell(film: Film) {
        if let urlString = film.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self.filmLogo.image = image
                case .failure:
                    self.filmLogo.image = nil
                }
            }
        } else {
            filmLogo.image = nil
        }
        filmNameLabel.text = film.trackName
        filmGenreLabel.text = film.primaryGenreName
        guard let dateString = film.releaseDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let yearString = String(year)
            filmYearLabel.text = yearString
        }
    }
    
    private func defaultConfigurations() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func addTargets() {
        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    private func setupUI() {
        contentView.bringSubviewToFront(favouriteButton)
        addSubview(favouriteButton)
        addSubview(filmNameLabel)
        addSubview(filmYearLabel)
        addSubview(filmGenreLabel)
        addSubview(filmLogo)
        filmNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(filmLogo.snp.leading)
        }
        filmYearLabel.snp.makeConstraints { make in
            make.top.equalTo(filmNameLabel.snp.bottom)
            make.leading.equalToSuperview()
        }
        filmGenreLabel.snp.makeConstraints { make in
            make.top.equalTo(filmYearLabel.snp.bottom)
            make.leading.equalToSuperview()
        }
        filmLogo.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalTo(100)
        }
        favouriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(filmLogo.snp.leading)
        }
    }
    
    @objc private func favouriteButtonPressed() {
        favouritesButtonHandler?()
    }
}
//MARK: - Cell state
//extension FilmTableViewCell {
//    enum CellState {
//        case favourite
//        case notFavorite
//    }
//
//    func applyState(state: CellState) {
//        func applyFavouriteState() {
//            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
//
//        func applyNotFavouriteState() {
//            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//
//        switch state {
//        case .favourite:
//            applyFavouriteState()
//        case .notFavorite:
//            applyNotFavouriteState()
//        }
//    }
//}
