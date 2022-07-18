// NSAttributedString+Extension.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation
import UIKit

extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }

    func attributedStringByTrimming(characterSet: CharacterSet)
        -> NSAttributedString
    {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharacters(in: characterSet)
        return NSAttributedString(attributedString: modifiedString)
    }

    func expandingTemplates() -> NSAttributedString {
        mapTemplates { attributedString in
            let templateComponents = attributedString.string.components(separatedBy: "|")
            let templateName = templateComponents.first ?? ""

            for modification in StringModifications.allModifications {
                if let attributedText = modification(templateName, templateComponents) {
                    return attributedText
                }
            }
            return "".attributed()
        }.attributedStringByTrimming(characterSet: .whitespacesAndNewlines)
    }

    func mapTemplates(
        transform: (_ templateString: NSAttributedString) -> NSAttributedString
    ) -> NSAttributedString {
        let countOfPrefixes = string.count(string: "{{")
        var result = self

        for _ in 0 ..< countOfPrefixes {
            guard
                let prefixRange = result.string.range(of: "{{", options: .backwards), // последнее вхождение {{
                let suffixRange = result.string.range(
                    of: "}}",
                    range: prefixRange.upperBound ..< result.string.endIndex
                ) // первое вхождение вхождение }} после prefixIndex
            else {
                return result
            }
            let inner = result.attributedSubstring(
                from: NSRange(
                    prefixRange.upperBound ..< suffixRange.lowerBound,
                    in: result.string
                )
            )
            let beforeMap = result.attributedSubstring(
                from: NSRange(
                    result.string.startIndex ..< prefixRange.lowerBound,
                    in: result.string
                )
            )
            let afterMap = result.attributedSubstring(
                from: NSRange(
                    suffixRange.upperBound ..< result.string.endIndex,
                    in: result.string
                )
            )
            result = beforeMap + transform(inner) + afterMap
        }
        return result
    }

    func color(_ color: UIColor) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.addAttributes(
            [.foregroundColor: color],
            range: NSRange(location: 0, length: string.count)
        )
        return mutableString
    }

    func font(_ font: UIFont) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.addAttributes(
            [.font: font],
            range: NSRange(location: 0, length: string.count)
        )
        return mutableString
    }
}
