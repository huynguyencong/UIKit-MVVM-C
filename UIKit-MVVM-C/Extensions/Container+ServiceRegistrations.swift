//
//  Container+ServiceRegistrations.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 22/12/2022.
//

import Foundation
import Swinject

extension Container {
    func registerServices() {
        register(APIManaging.self) { resolver in
            APIManager()
        }
        .inObjectScope(.container)
        
        register(ArticleNetworkServicing.self) { resolver in
            ArticleNetworkService(apiManager: resolver.resolve(APIManaging.self)!)
        }
        .inObjectScope(.container)
        
        register(AuthenticationNetworkServicing.self) { resolver in
            AuthenticationNetworkService(apiManager: resolver.resolve(APIManaging.self)!)
        }
        .inObjectScope(.container)
        
        register(StoreServicing.self) { resolver in
            StoreService(articleNetworkService: resolver.resolve(ArticleNetworkServicing.self)!)
        }
        .inObjectScope(.container)
        
        register(SessionManaging.self) { resolver in
            SessionManager(authenticationNetworkService: resolver.resolve(AuthenticationNetworkServicing.self)!)
        }
        .inObjectScope(.container)
    }
}
