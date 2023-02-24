//
//  Friends.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 24/02/2023.
//

import Foundation

struct Friend {
    var name: String
    var messages: [String]
    var number: Int
    var theme: Theme
}

extension Friend {
    static let sampleData: [Friend] =
    [
        Friend(name: "Friend 1", messages: ["Hello", "Goodbye"], number: 01234, theme: .yellow),
        Friend(name: "Friend 2", messages: ["HELP", "LOCATION"], number: 56789, theme: .orange)
    ]
}
