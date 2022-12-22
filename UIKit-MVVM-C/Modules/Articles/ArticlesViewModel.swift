//
//  ArticlesViewModel.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 14/12/2022.
//

import Foundation
import Combine

class ArticlesViewModel: ViewModelType {
    @Published var articles: [Article] = []
    @Published var cellModels: [ArticleCollectionViewCell.ViewModel] = []
    let errorSubject = PassthroughSubject<Error, Never>()
    var cancellables = Set<AnyCancellable>()
    
    let storeService: StoreServicing
    
    init(storeService: StoreServicing) {
        self.storeService = storeService
        bind()
        fetchData()
    }
    
    func bind() {
        $articles
            .compactMap({ [weak self] in self?.createCellModels(from: $0) })
            .assign(to: &$cellModels)
    }
    
    private func fetchData() {
        storeService.fetchArticles().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorSubject.send(error)
            }
        } receiveValue: { [weak self] articles in
            self?.articles = articles
        }
        .store(in: &cancellables)
    }
    
    private func createCellModels(from articles: [Article]) -> [ArticleCollectionViewCell.ViewModel] {
        articles.map({ ArticleCollectionViewCell.ViewModel(id: $0.id, title: $0.title, imageURL: $0.imageURL) })
    }
}
