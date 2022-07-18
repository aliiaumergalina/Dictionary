// String+Extension.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation
import UIKit

extension String {
    // MARK: Lifecycle

    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]

        guard
            let attributedString = try? NSAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            )
        else {
            return nil
        }

        self.init(attributedString.string)
    }

    // MARK: Internal

    var escapingHTML: String? {
        String(htmlEncodedString: self)
    }

    func innerString(
        prefix: String,
        suffix: String,
        suffixOptions: NSString.CompareOptions = .backwards
    ) -> String? {
        guard
            let prefixRange = range(of: prefix),
            let suffixRange = range(
                of: suffix, options: suffixOptions, range: prefixRange.upperBound ..< endIndex
            )
        else {
            return nil
        }
        return String(self[prefixRange.upperBound ..< suffixRange.lowerBound])
    }

    func mapInnerString(
        prefix: String,
        suffix: String,
        skipPrefixAnSufix: Bool,
        transform: (String) -> String
    ) -> String {
        var result = self
        var searchStartIndex = startIndex

        while searchStartIndex < result.endIndex {
            guard
                let prefixRange = result.range(
                    of: prefix,
                    range: searchStartIndex ..< result.endIndex
                ),
                let suffixRange = result.range(
                    of: suffix,
                    range: prefixRange.upperBound ..< result.endIndex
                )
            else {
                return result
            }
            let inner = String(result[prefixRange.upperBound ..< suffixRange.lowerBound])

            if skipPrefixAnSufix {
                let beforeMap = String(result[result.startIndex ..< prefixRange.lowerBound])
                let afterMap = String(result[suffixRange.upperBound ..< result.endIndex])
                result = beforeMap + transform(inner) + afterMap
                searchStartIndex = prefixRange.lowerBound
            } else {
                let beforeMap = String(result[result.startIndex ..< prefixRange.upperBound])
                let afterMap = String(result[suffixRange.lowerBound ..< result.endIndex])
                result = beforeMap + transform(inner) + afterMap
                searchStartIndex = suffixRange.upperBound
            }
        }
        return result
    }

    /// stringToFind must be at least 1 character.
    func count(string: String) -> Int {
        assert(!string.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?

        while let foundRange = range(of: string, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }

    func attributed() -> NSAttributedString {
        NSAttributedString(string: self)
    }
}
