//
//  ArticleNetworkServicing.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation
import Combine

protocol ArticleNetworkServicing {
    func fetchArticles() -> AnyPublisher<[Article], Error>
}
