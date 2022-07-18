// WordParser.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class WordParser {
    // MARK: Internal

    func parse(text: String, completion: @escaping (Result<WordDetails, Error>) -> Void) {
        let group = DispatchGroup()
        var meanings: [NSAttributedString]?
        var urls: [URL]?
        var etymology: NSAttributedString?

        group.enter()
        meaningParser.parseMeanings(wikiText: text) { result in
            meanings = try? result.get()
            group.leave()
        }

        group.enter()
        imageParser.parseImageURLs(text: text) { result in
            urls = try? result.get()
            group.leave()
        }

        group.enter()
        etymologyParser.parseEtymology(text: text) { result in
            etymology = try? result.get()
            group.leave()
        }

        group.notify(queue: .main) {
            let wordDetails = WordDetails(
                meanings: meanings ?? [NSAttributedString](),
                imagesURLs: urls ?? [URL](),
                etymology: etymology ?? "".attributed()
            )
            completion(.success(wordDetails))
        }
    }

    // MARK: Private

    private let meaningParser = MeaningParser()
    private let imageParser = ImageParser()
    private let etymologyParser = EtymologyParser()
}
