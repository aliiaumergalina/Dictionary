// ReusableCell+Extension.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation
import UIKit

// MARK: - ReusableView

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        String(describing: self)
    }
}

// MARK: - NibLoadableView

public protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        String(describing: self)
    }
}

// UICollectionView + Reusable Cell
extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionReusableView>(
        _: T.Type,
        forSupplementaryViewOfKind kind: String
    ) where T: ReusableView {
        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.defaultReuseIdentifier
        )
    }

    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T
        where T: ReusableView
    {
        register(T.self)
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath)
            as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        for indexPath: IndexPath
    ) -> T where T: ReusableView, T: NibLoadableView {
        register(T.self)
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath)
            as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> T where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: kind)
        guard
            let cell = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: T.defaultReuseIdentifier,
                for: indexPath
            ) as? T
        else {
            fatalError(
                "Could not dequeue reusable supplementaryView with identifier: \(T.defaultReuseIdentifier)"
            )
        }
        return cell
    }
}

// UITableView + Reusable cell
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath
    ) -> T where T: NibLoadableView {
        register(T.self)
        guard
            let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        register(T.self)
        guard
            let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        _: T.Type
    ) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T
        where T: ReusableView
    {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T
        else {
            fatalError(
                "Could not dequeue Reusable HeaderFooterView with identifier: \(T.defaultReuseIdentifier)"
            )
        }
        return cell
    }
}

// MARK: - UITableViewCell + ReusableView

extension UITableViewCell: ReusableView {}
