// ImageParser.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

final class ImageParser {
    // MARK: Internal

    func parseImageURLs(text: String, completion: @escaping (Result<[URL], Error>) -> Void) {
        var imagesNames = [String]()
        let illustrationsString = text.innerString(
            prefix: "=== Семантические свойства ===\n",
            suffix: "\n\n",
            suffixOptions: []
        )!
        let illustrations = illustrationsString.components(separatedBy: "\n")

        for illustrationTemplate in illustrations {
            let attributedImageName = illustrationTemplate.attributed().expandingTemplates()
            if !attributedImageName.string.isEmpty, !attributedImageName.string.hasSuffix(".svg") {
                imagesNames.append(attributedImageName.string)
            }
        }
        parseImagesURL(imagesNames: imagesNames, completion: completion)
    }

    // MARK: Private

    private func parseImagesURL(
        imagesNames: [String],
        completion: @escaping (Result<[URL], Error>) -> Void
    ) {
        var imagesURLs = [URL]()
        let group = DispatchGroup()

        for imageName in imagesNames {
            guard let url = makeURL(imageName: imageName) else {
                completion(.failure(RuntimeError(descriprion: "invalid URL")))
                return
            }
            let session = URLSession.shared
            group.enter()
            let dataTask = session.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        if let result = try? self.parseImageURL(jsonData: data).get() {
                            imagesURLs.append(result)
                        }
                    }
                }
                group.leave()
            }
            dataTask.resume()
        }
        group.notify(queue: .main) {
            completion(.success(imagesURLs))
        }
    }

    private func makeURL(imageName: String) -> URL? {
        var urlComponents = URLComponents(string: "https://ru.wikipedia.org/w/api.php")
        urlComponents?.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "imageinfo"),
            URLQueryItem(name: "iiprop", value: "url"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "titles", value: "Image:" + imageName),
        ]
        return urlComponents?.url
    }

    private func parseImageURL(jsonData: Data) -> Result<URL, Error> {
        guard
            let rawDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
            let queryDictionary = rawDictionary["query"] as? [String: Any],
            let pagesDictionary = queryDictionary["pages"] as? [String: Any],
            let imageInfoContainerDictionary = pagesDictionary["-1"] as? [String: Any],
            let imageInfos = imageInfoContainerDictionary["imageinfo"] as? [[String: String]]
        else {
            return .failure(RuntimeError(descriprion: "parsing failed"))
        }
        for item in imageInfos {
            if let urlString = item["url"] {
                return .success(URL(string: urlString)!)
            }
        }
        return .failure(RuntimeError(descriprion: "parsing failed"))
    }
}
