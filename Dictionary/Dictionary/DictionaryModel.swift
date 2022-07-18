// DictionaryModel.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class DictionaryModel {
    // MARK: Internal

    func download(
        searchBarText: String,
        completion: @escaping (Result<[Word], Error>) -> Void
    ) {
        if searchBarText.isEmpty {
            completion(.success([]))
            return
        }
        var urlComponents = URLComponents(string: "https://ru.wiktionary.org/w/api.php")
        urlComponents?.queryItems = [
            URLQueryItem(name: "action", value: "opensearch"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "utf8", value: nil),
            URLQueryItem(name: "search", value: searchBarText),
            URLQueryItem(name: "namespace", value: "0"),
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "suggest", value: "true"),
        ]
        guard let url = urlComponents?.url else {
            completion(.failure(RuntimeError(descriprion: "invalid URL")))
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    let wordsResult = self.parse(data: data)
                    completion(wordsResult)
                }
            }
        }
        dataTask.resume()
    }

    // MARK: Private

    private func parse(data: Data) -> Result<[Word], Error> {
        var results = [Word]()
        guard
            let rawArrays = try? JSONSerialization.jsonObject(with: data) as? [Any],
            let words = rawArrays[safe: 1] as? [String],
            let urls = rawArrays[safe: 3] as? [String]
        else {
            return .failure(RuntimeError(descriprion: "parsing failed"))
        }
        for index in words.indices {
            var urlComponents = URLComponents(string: urls[index])
            urlComponents?.queryItems = [URLQueryItem(name: "action", value: "raw")]
            let word = Word(name: words[index], url: urlComponents!.url!)
            results.append(word)
        }
        return .success(results)
    }
}
