//
//  StoreService.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 19/12/2022.
//

import Foundation
import Combine

class StoreService: StoreServicing {
    let articleNetworkService: ArticleNetworkServicing
    
    init(articleNetworkService: ArticleNetworkServicing) {
        self.articleNetworkService = articleNetworkService
    }
    
    func fetchArticles() -> AnyPublisher<[Article], Error> {
        articleNetworkService.fetchArticles()
    }
}
