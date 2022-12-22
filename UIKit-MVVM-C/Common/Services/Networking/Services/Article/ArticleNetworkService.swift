//
//  ArticleNetworkService.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation
import Combine

class ArticleNetworkService: ArticleNetworkServicing {
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
    
    func fetchArticles() -> AnyPublisher<[Article], Error> {
        apiManager.request(target: ArticleTarget.list, responseType: ArticlesResponse.self, jsonDecoder: nil)
            .map({ $0.articles })
            .eraseToAnyPublisher()
    }
}
