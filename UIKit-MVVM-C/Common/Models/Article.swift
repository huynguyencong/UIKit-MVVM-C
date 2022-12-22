//
//  Article.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 14/12/2022.
//

import Foundation

struct Article: Decodable {
    let id: String
    let title: String
    let imageURL: URL?
}

struct ArticlesResponse: Decodable {
    let articles: [Article]
}
