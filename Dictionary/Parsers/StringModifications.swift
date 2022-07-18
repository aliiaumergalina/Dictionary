// StringModifications.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import Foundation
import UIKit

// swiftlint: disable opening_brace
// swiftlint: disable type_body_length
enum StringModifications {
    typealias Modification = (
        _ templateName: String,
        _ templateComponents: [String]
    ) -> NSAttributedString?

    static let italicFont = UIFont.italicSystemFont(ofSize: 17)

    static let allModifications: [Modification] = [
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if
                templateName == "пример",
                let text = templateComponents[safe: 1],
                !text.isEmpty,
                let color = UIColor(named: "ExampleTextColor")
            {
                return ("\n\u{2022} " + text).attributed()
                    .color(color)
                    .font(.italicSystemFont(ofSize: 16))
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "п." {
                return "перен.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "спорт." {
                return "спорт.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "жарг." {
                return "жарг.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "неол." {
                return "неол.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "военн." {
                return "воен.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "разг." {
                return "разг.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "техн." {
                return "техн.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "устар." {
                return "устар.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "истор." {
                return "истор.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "лингв." {
                return "лингв.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "исч." {
                return "исч.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "бран." {
                return "бран.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "книжн." {
                return "книжн.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "поэт." {
                return "поэт.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "биол." {
                return "биол.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "зоол." {
                return "зоол.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "шутл." {
                return "шутл.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "ирон." {
                return "ирон.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "комп." {
                return "комп.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "собират." {
                return "собират.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "субстантивир." {
                return "субстантивир.".attributed()
                    .color(.secondaryLabel)
                    .font(italicFont)
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "итп " {
                return "".attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, _) -> NSAttributedString? in
            if templateName == "спец." {
                return "".attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if templateName == "выдел" {
                return (templateComponents[safe: 1] ?? "").attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if templateName == "t:=", let text = templateComponents[safe: 1] {
                return ("то же, что " + text).attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if templateName == "женск.", let text = templateComponents[safe: 2] {
                return ("женск. к " + text).attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if templateName == "действие", let text = templateComponents[safe: 1] {
                return (templateName + " по значению гл. " + text).attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if templateName == "прич.", let text = templateComponents[safe: 1] {
                return (templateName + " от " + text).attributed()
            } else {
                return nil
            }
        },
        { (templateName: String, templateComponents: [String]) -> NSAttributedString? in
            if
                templateName.trimmingCharacters(in: .whitespaces) == "илл",
                let text = templateComponents[safe: 1]
            {
                return text.attributed()
            } else {
                return nil
            }
        },
    ]
}
