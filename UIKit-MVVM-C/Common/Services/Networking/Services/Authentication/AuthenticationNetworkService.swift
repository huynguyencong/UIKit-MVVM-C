//
//  AuthenticationNetworkService.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Combine

class AuthenticationNetworkService: AuthenticationNetworkServicing {
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        let target = AuthenticationTarget.signIn(email, password)
        return apiManager.request(target: target, responseType: User.self, jsonDecoder: nil)
    }
}
