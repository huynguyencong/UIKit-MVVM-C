//
//  TestInstances.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 31/12/2022.
//

import Foundation
@testable import UIKit_MVVM_C

extension User {
    static func createTestInstance() throws -> User {
        try JSONLoader().load(fileName: "User.json")
    }
}

extension Article {
    static func createTestInstances() throws -> [Article] {
        let responseObject: ArticlesResponse = try JSONLoader().load(fileName: "Articles.json")
        return responseObject.articles
    }
}
