// WordViewController.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

// MARK: - WordViewController

final class WordViewController: UIViewController {
    // MARK: Lifecycle

    init(model: WordModel) {
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
        navigationItem.title = model.word.name
        navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        model.loadWordDetails { [weak self] wordDetails in
            switch wordDetails {
            case .success(let result):
                self?.set(wordDetails: result)
            case .failure:
                break
            }
        }
        setupButtons()
    }

    @objc
    func didTapLikeButton() {
        model.userDidToggle(word: model.word)
        configureLikeButton()
    }

    @objc
    func share(sender: UIView) {
        let textToShare = "Поделиться словом"
        var urlToShare = URLComponents(url: model.word.url, resolvingAgainstBaseURL: true)
        urlToShare?.query = nil
        guard
            let url = urlToShare?.url,
            let objectsToShare = [textToShare, url] as? [Any]
        else { return }
        let activityVC = UIActivityViewController(
            activityItems: objectsToShare,
            applicationActivities: nil
        )
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.assignToContact,
        ]

        activityVC.popoverPresentationController?.sourceView = sender
        present(activityVC, animated: true, completion: nil)
    }

    // MARK: Private

    private enum Row {
        case images([URL])
        case text(NSAttributedString)
    }

    private struct Section {
        let title: String
        let rows: [Row]
    }

    private let model: WordModel
    private var details: WordDetails?
    private var sections = [Section]()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var likeButton: UIBarButtonItem?
    private var shareButton: UIBarButtonItem?
    private let noDetailsLabel = UILabel()

    private func setupButtons() {
        let likeButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapLikeButton)
        )
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(share(sender:))
        )

        self.likeButton = likeButton
        self.shareButton = shareButton
        navigationItem.rightBarButtonItems = [likeButton, shareButton]
        configureLikeButton()
    }

    private func configureLikeButton() {
        if LikeManager.shared.isLiked(word: model.word) {
            let heartImageFilled = UIImage(systemName: "heart.fill")
            likeButton?.tintColor = .systemRed
            likeButton?.image = heartImageFilled
        } else {
            let heartImage = UIImage(systemName: "heart")
            likeButton?.tintColor = .systemGray
            likeButton?.image = heartImage
        }
    }

    private func set(wordDetails: WordDetails) {
        details = wordDetails
        if !wordDetails.imagesURLs.isEmpty {
            sections = [
                Section(
                    title: "Изображения",
                    rows: [Row.images(wordDetails.imagesURLs)]
                ),
            ]
        }
        if !wordDetails.etymology.string.isEmpty {
            sections.append(
                Section(
                    title: "Этимология",
                    rows: [Row.text(wordDetails.etymology)]
                )
            )
        }
        if !wordDetails.meanings.isEmpty {
            sections.append(
                Section(
                    title: "Значения",
                    rows: wordDetails.meanings.map { Row.text($0) }
                )
            )
        }
        if sections.isEmpty {
            setupNoDetailsLabel()
        }
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(WordMeaningCell.self)
        tableView.register(WordImageCell.self)
    }

    private func setupNoDetailsLabel() {
        noDetailsLabel.text = "Значение отсутствует"
        noDetailsLabel.font = .preferredFont(forTextStyle: .body)
        noDetailsLabel.textColor = .systemGray
        view.addSubview(noDetailsLabel)
        noDetailsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension WordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .images(let url):
            let cell: WordImageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(urls: url, controller: self)
            return cell
        case .text(let meaning):
            let cell: WordMeaningCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(meaning: meaning)
            return cell
        }
    }
}
