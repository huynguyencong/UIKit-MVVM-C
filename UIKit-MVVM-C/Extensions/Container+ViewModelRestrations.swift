//
//  Container+ViewModelRestration.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 22/12/2022.
//

import Foundation
import Swinject

extension Container {
    func registerViewModels() {
        register(ArticleViewModel.self) { _, article in
            ArticleViewModel(article: article)
        }
        
        register(ArticlesViewModel.self) { resolver in
            ArticlesViewModel(storeService: resolver.resolve(StoreServicing.self)!)
        }
        
        register(SignInViewModel.self) { resolver in
            SignInViewModel(sessionManager: resolver.resolve(SessionManaging.self)!)
        }
    }
}
