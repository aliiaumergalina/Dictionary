// LikedWordsController.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

// MARK: - LikedWordsController

final class LikedWordsController: UIViewController {
    // MARK: Lifecycle

    init(model: LikedWordsModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Избранное"
        likedWords = LikeManager.shared.likedWords
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedWords = LikeManager.shared.likedWords
        likedWordsTableView.reloadData()
    }

    // MARK: Private

    private var likedWords = [Word]()
    private let likedWordsTableView = UITableView(frame: .zero, style: .plain)
    private let model: LikedWordsModel

    private func setupTableView() {
        likedWordsTableView.delegate = self
        likedWordsTableView.dataSource = self
        view.addSubview(likedWordsTableView)
        likedWordsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likedWordsTableView.register(UITableViewCell.self)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension LikedWordsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        likedWords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = likedWords[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel = WordModel(word: likedWords[indexPath.row])
        let wordController = WordViewController(model: wordModel)
        navigationController?.pushViewController(wordController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
