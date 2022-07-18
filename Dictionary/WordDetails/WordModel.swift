// WordModel.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class WordModel {
    // MARK: Lifecycle

    init(word: Word) {
        self.word = word
    }

    // MARK: Internal

    let word: Word

    func loadWordDetails(completion: @escaping (Result<WordDetails, Error>) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: word.url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    if let text = String(data: data, encoding: .utf8) {
                        self.parser.parse(text: text, completion: completion)
                    }
                }
            }
        }
        dataTask.resume()
    }

    func userDidToggle(word: Word) {
        LikeManager.shared.toggle(word: word)
    }

    // MARK: Private

    private let parser = WordParser()
}
