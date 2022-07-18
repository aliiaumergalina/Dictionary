// LikeManager.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class LikeManager {
    // MARK: Lifecycle

    private init() {
        if
            let data = UserDefaults.standard.data(forKey: userDefaultsKey),
            let decoded = try? JSONDecoder().decode([Word].self, from: data)
        {
            likedWords = decoded
        }
    }

    // MARK: Internal

    static let shared = LikeManager()

    private(set) var likedWords = [Word]()

    func isLiked(word: Word) -> Bool {
        for item in likedWords where item.name == word.name {
            return true
        }
        return false
    }

    func toggle(word: Word) {
        for index in 0 ..< likedWords.count where likedWords[index].name == word.name {
            likedWords.remove(at: index)
            save()
            return
        }
        likedWords.append(word)
        save()
    }

    // MARK: Private

    private let userDefaultsKey = "key"

    private func save() {
        if let encoded = try? JSONEncoder().encode(likedWords) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}
