// DictionaryViewController.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

// MARK: - DictionaryViewController

final class DictionaryViewController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Словарь"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        setupTableView()
        setupStatusLabel()
        settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(didTapSettingsButton)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc
    func didTapSettingsButton() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: Private

    private let model = DictionaryModel()
    private let statusLabel = UILabel()
    private var results = [Word]()
    private let wordsTableView = UITableView(frame: .zero, style: .plain)
    private var isSearched = false
    private var settingsButton: UIBarButtonItem?

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск..."
        return searchController
    }()

    private func setupTableView() {
        wordsTableView.delegate = self
        wordsTableView.dataSource = self
        view.addSubview(wordsTableView)
        wordsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wordsTableView.register(UITableViewCell.self)
    }

    private func setupStatusLabel() {
        statusLabel.text = "Введите слово в строку поиска"
        statusLabel.font = .preferredFont(forTextStyle: .body)
        statusLabel.textColor = .systemGray
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func search(text: String) {
        model.download(searchBarText: text) { wordsResult in
            switch wordsResult {
            case .success(let words):
                self.results = words
                self.wordsTableView.reloadData()
                if self.results.isEmpty {
                    self.statusLabel.text = "Ничего не найдено"
                    self.statusLabel.isHidden = false
                }
            case .failure:
                self.showErrorAlert()
            }
        }
        isSearched = true
        statusLabel.isHidden = true
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка", message: "Ошибка при загрузке данных", preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension DictionaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = results[indexPath.row].name
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel = WordModel(word: results[indexPath.row])
        let wordController = WordViewController(model: wordModel)
        navigationController?.pushViewController(wordController, animated: true)
    }
}

// MARK: UISearchResultsUpdating

extension DictionaryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        search(text: searchController.searchBar.text!)
    }
}
