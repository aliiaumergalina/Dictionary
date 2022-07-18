// LikedWordsModel.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class LikedWordsModel {
    func getLikedWords() -> [Word] {
        LikeManager.shared.likedWords
    }
}
