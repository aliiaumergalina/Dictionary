// VersionCell.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

final class VersionCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureVersionLabel()
        configureVersionNumberLabel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    static let identifier = "VersionCell"

    // MARK: Private

    private let versionLabel = UILabel()
    private let versionNumberLabel = UILabel()

    private func configureVersionLabel() {
        versionLabel.text = "Версия"
        versionLabel.font = .preferredFont(forTextStyle: .body)
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
        }
    }

    private func configureVersionNumberLabel() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        versionNumberLabel.text = appVersion + " (" + buildNumber + ")"
        versionNumberLabel.font = .preferredFont(forTextStyle: .body)
        versionNumberLabel.textColor = .secondaryLabel
        contentView.addSubview(versionNumberLabel)
        versionNumberLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
