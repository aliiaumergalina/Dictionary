// Collection+Extension.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
