// WordImageCell.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import ImageViewer
import Nuke
import SnapKit
import UIKit

// MARK: - WordImageCell

final class WordImageCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupCollectionView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(urls: [URL], controller: UIViewController) {
        self.urls = urls
        controllerToPresent = controller
        galleryItems = urls.map { url in
            GalleryItem.image { imageCompletion in
                Nuke.ImagePipeline.shared.loadImage(
                    with: url,
                    completion: { result in
                        imageCompletion(try? result.get().image)
                    }
                )
            }
        }
        imagesCollectionView.reloadData()
    }

    // MARK: Private

    private let imagesCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var urls = [URL]()
    private var galleryItems = [GalleryItem]()
    private weak var controllerToPresent: UIViewController?

    private func setupCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        imagesCollectionView.collectionViewLayout = layout
        contentView.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(160)
        }
        imagesCollectionView.register(ImagesCollectionViewCell.self)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension WordImageCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        urls.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: ImagesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(imageURL: urls[indexPath.item])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controllerToPresent?.presentImageGallery(
            GalleryViewController(
                startIndex: indexPath.item,
                itemsDataSource: self,
                configuration: [.deleteButtonMode(.none)]
            )
        )
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension WordImageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath
    ) -> CGSize {
        let itemsPerRow = (contentView.frame.width / 180).rounded(.down)
        guard itemsPerRow != 0 else {
            assertionFailure()
            return CGSize(width: 1, height: 1)
        }
        let paddingSpace = insets.left * (itemsPerRow + 1)
        let availableWidth = contentView.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow).rounded(.down)
        return CGSize(width: widthPerItem, height: 160)
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetForSectionAt _: Int
    ) -> UIEdgeInsets {
        insets
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        insets.left
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        insets.left
    }
}

// MARK: GalleryItemsDataSource

extension WordImageCell: GalleryItemsDataSource {
    func itemCount() -> Int {
        galleryItems.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        galleryItems[index]
    }
}
