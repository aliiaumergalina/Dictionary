// SettingsViewController.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import SnapKit
import UIKit

// MARK: - SettingsViewController

final class SettingsViewController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        rows = [.version, .policy]
        navigationItem.title = "Настройки"
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: Private

    private enum Row {
        case version
        case policy
    }

    private var settingsTableView = UITableView(frame: .zero, style: .insetGrouped)
    private var rows = [Row]()

    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        view.addSubview(settingsTableView)
        settingsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        settingsTableView.register(VersionCell.self, forCellReuseIdentifier: VersionCell.identifier)
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .version:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: VersionCell.identifier,
                    for: indexPath
                ) as? VersionCell
            else {
                return UITableViewCell()
            }
            return cell
        case .policy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Политика конфиденциальности"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .policy:
            let policyVC = PrivacyPolicyController()
            navigationController?.pushViewController(policyVC, animated: true)
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
