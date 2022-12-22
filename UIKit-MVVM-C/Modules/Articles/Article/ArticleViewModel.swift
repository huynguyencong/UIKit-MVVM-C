//
//  ArticleViewModel.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation

class ArticleViewModel: ViewModelType {
    @Published var article: Article?
    
    init(article: Article) {
        self.article = article
    }
    
    func bind() {}
}
