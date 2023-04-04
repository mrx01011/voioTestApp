//
//  DetailFilmViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class DetailFilmViewController: UIViewController {
    private var FilmStringUrl = ""
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
    private let descriotionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Description"
        textView.textColor = .black
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    //MARK: Initialization
    init(film: Film) {
        super.init(nibName: nil, bundle: nil)
        FilmStringUrl = film.collectionViewURL ?? ""
        nameLabel.text = film.trackName
        genreLabel.text = film.primaryGenreName
        descriotionTextView.text = film.longDescription
        // setup image view
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
        // setup date label
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
        addTargets()
    }
    //MARK: Methods
    private func addTargets() {
        shareButton.addTarget(self, action: #selector(shareConvertedInfo), for: .touchUpInside)
    }
    
    private func defaultConfigurations() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    private func setupUI() {
        view.addSubview(yearLabel)
        view.addSubview(nameLabel)
        view.addSubview(filmLogo)
        view.addSubview(genreLabel)
        view.addSubview(descriotionTextView)
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
        descriotionTextView.snp.makeConstraints { make in
            make.top.equalTo(filmLogo.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func shareConvertedInfo() {
        if !FilmStringUrl.isEmpty {
            guard let filmURL = URL(string: FilmStringUrl) else { return }
            let activityViewController = UIActivityViewController(activityItems: [filmURL], applicationActivities: nil)
            self.present(activityViewController, animated: true)
        } else {
            alertOK(title: "Sorry", message: "Movie link not available")
        }
    }
}
