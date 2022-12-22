//
//  ArticleTarget.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation
import Moya

enum ArticleTarget: TargetType {
    case list
    
    var baseURL: URL {
        URL(string: "https://demo0195348.mockable.io")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "github-mvvmc/articles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .list:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
