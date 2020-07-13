//
//  Dysprosium.swift
//  ios-library
//
//  Created by Bas van Kuijck on 07-01-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

import Foundation
import Dysprosium
import Lithium
import Logging

extension LithiumLogger {
    public func setupWithDysprosium() {
        Dysprosium.shared.isEnabled = true

        let style = LogStyle()
        if self.theme is EmojiLogTheme {
            style.prefixText = "☠️ DEA"

        } else if self.theme is DefaultLogTheme {
            style.prefixText = "Dealloc"

        } else {
            style.prefixText = "DEA"
        }

        Dysprosium.shared.onDealloc { models in
            var strArray: [String] = []
            var classesDone: [String] = []

            // Iterate through the current deallocated models
            // To find any double classnames
            // So you will get <x> <Classname> instances
            for model in models {
                let filteredArray = models.filter { model.className == $0.className }
                let count = filteredArray.count
                if count == 1 {
                    strArray.append(model.description)

                } else {
                    if !classesDone.contains(model.className) {
                        strArray.append(String(format: "%@ %@ %@", String(count), model.classNameDescription, "instances"))
                        classesDone.append(model.className)
                    }
                }
            }
            guard var str = strArray.first else {
                return
            }

            if strArray.count > 1 {
                let lastObject = strArray.last!
                strArray.removeLast()
                str = String(format: "%@ %@ %@", strArray.joined(separator: ", "), "and", lastObject)
            }

            log(level: .trace, message: Logger.Message(stringLiteral: str), metadata: [ "tag": "dealloc" ], file: "", function: "", line: 0)
        }

        Dysprosium.shared.onExpectedDeallocation { obj, reason in
            let str = "\(obj) not being deallocated \(reason)"
            log(level: .trace, message: Logger.Message(stringLiteral: str), metadata: [ "tag": "dealloc" ], file: "", function: "", line: 0)
        }
    }
}
