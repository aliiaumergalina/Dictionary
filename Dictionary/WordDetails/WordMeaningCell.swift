// WordMeaningCell.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

final class WordMeaningCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMeaningLabel()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(meaning: NSAttributedString) {
        meaningLabel.attributedText = meaning
    }

    // MARK: Private

    private let meaningLabel = UILabel()

    private func setupMeaningLabel() {
        selectionStyle = .none
        meaningLabel.font = .preferredFont(forTextStyle: .body)
        meaningLabel.numberOfLines = 0
    }

    private func setupLayout() {
        contentView.addSubview(meaningLabel)
        meaningLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
