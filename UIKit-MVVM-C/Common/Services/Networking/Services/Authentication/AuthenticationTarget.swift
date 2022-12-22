//
//  AuthenticationTarget.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Moya

enum AuthenticationTarget: TargetType {
    case signIn(String, String)
    
    var baseURL: URL {
        URL(string: "https://demo0195348.mockable.io")!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "github-mvvmc/sign-in"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let email, let password):
            let params = [
                "email": email,
                "password": password
            ]
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
