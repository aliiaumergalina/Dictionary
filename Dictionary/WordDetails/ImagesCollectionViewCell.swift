// ImagesCollectionViewCell.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Nuke
import SnapKit
import UIKit

final class ImagesCollectionViewCell: UICollectionViewCell, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(imageURL: URL) {
        Nuke.loadImage(with: imageURL, into: imageView)
    }

    // MARK: Private

    private let imageView = UIImageView()

    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
