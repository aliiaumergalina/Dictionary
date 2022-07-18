// EtymologyParser.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class EtymologyParser {
    // MARK: Internal

    func parseEtymology(
        text: String,
        completion: @escaping (Result<NSAttributedString, Error>) -> Void
    ) {
        let etymologyString = text.innerString(
            prefix: "=== Этимология ===\n",
            suffix: "\n",
            suffixOptions: []
        )!
        if etymologyString.contains("{{этимология:|да}}") {
            completion(.success("".attributed()))
            return
        }
        guard let url = makeExpandURL(etymology: etymologyString) else {
            completion(.failure(RuntimeError(descriprion: "invalid URL")))
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    completion(self.parseEtymology(jsonData: data))
                }
            } else {
                completion(.failure(RuntimeError(descriprion: "No data")))
            }
        }
        dataTask.resume()
    }

    // MARK: Private

    private func makeExpandURL(etymology: String) -> URL? {
        var urlComponents = URLComponents(string: "https://ru.wiktionary.org/w/api.php")
        urlComponents?.queryItems = [
            URLQueryItem(name: "action", value: "expandtemplates"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "text", value: etymology),
        ]
        return urlComponents?.url
    }

    private func parseEtymology(jsonData: Data) -> Result<NSAttributedString, Error> {
        guard
            let rawDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
            let parsedEtymology = rawDictionary["expandtemplates"] as? [String: String],
            let value = parsedEtymology["*"]
        else {
            return .failure(RuntimeError(descriprion: "parsing failed"))
        }
        let etymologyWithoutHTML = value.escapingHTML
        guard
            let mappedEtymology = etymologyWithoutHTML?.mapInnerString(
                prefix: "[[",
                suffix: "]]",
                skipPrefixAnSufix: true,
                transform: { string in
                    String(string.split(separator: "|").last ?? "")
                }
            )
        else {
            return .failure(RuntimeError(descriprion: "parsing failed"))
        }
        return .success(mappedEtymology.attributed())
    }
}
