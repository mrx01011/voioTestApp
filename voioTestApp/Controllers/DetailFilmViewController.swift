//
//  DetailFilmViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class DetailFilmViewController: UIViewController {
    //MARK: UI elements
    private let filmLogo = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Film name"
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genre"
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let descriotionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    //MARK: Initialization
    init(film: Film) {
        super.init(nibName: nil, bundle: nil)
        nameLabel.text = film.trackName
        genreLabel.text = film.primaryGenreName
        descriotionLabel.text = film.longDescription
        
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
        
        if let dateString = film.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = dateFormatter.date(from: dateString) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let yearString = String(year)
                yearLabel.text = yearString
            }
        } else { return }
        
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    private func setupUI() {
        view.addSubview(yearLabel)
        view.addSubview(nameLabel)
        view.addSubview(filmLogo)
        view.addSubview(genreLabel)
        view.addSubview(descriotionLabel)
        // film name
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.lessThanOrEqualTo(filmLogo.snp.trailing)
        }
        // film logo
        filmLogo.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(200)
        }
        // film year
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        // film genre
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        // film description
        descriotionLabel.snp.makeConstraints { make in
            make.top.equalTo(filmLogo.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}