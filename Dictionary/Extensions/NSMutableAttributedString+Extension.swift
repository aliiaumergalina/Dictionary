// NSMutableAttributedString+Extension.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation

extension NSMutableAttributedString {
    func trimCharacters(in set: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: set as CharacterSet)

        // Trim leading characters from character set.
        while range.length != 0, range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: set)
        }

        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: set, options: .backwards)
        while range.length != 0, NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: set, options: .backwards)
        }
    }
}
