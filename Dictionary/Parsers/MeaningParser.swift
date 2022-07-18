// MeaningParser.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class MeaningParser {
    func parseMeanings(
        wikiText: String,
        completion: @escaping (Result<[NSAttributedString], Error>) -> Void
    ) {
        // вычленяем из общего текста значения
        let meaningsString = wikiText.innerString(
            prefix: "==== Значение ====\n",
            suffix: "\n\n",
            suffixOptions: []
        )!
        let meaninigsArray = meaningsString.components(separatedBy: "\n#")
        // убираем ссылки и решетки
        var arrayWithoutLinks = [NSAttributedString]()

        for string in meaninigsArray {
            var mappedString = string.description.mapInnerString(
                prefix: "[[",
                suffix: "]]",
                skipPrefixAnSufix: true
            ) { string in
                String(string.split(separator: "|").last ?? "")
            }
            if mappedString.hasPrefix("#") {
                mappedString = String(mappedString.dropFirst(1))
                    .trimmingCharacters(in: .whitespaces)
            }
            let attributedString = mappedString.attributed().expandingTemplates()
            if !attributedString.string.isEmpty {
                arrayWithoutLinks.append(attributedString)
            }
        }
        completion(.success(arrayWithoutLinks))
    }
}
