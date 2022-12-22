//
//  APIManager.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation
import Moya
import Combine
import CombineMoya

class APIManager: APIManaging {
    let provider = MoyaProvider<MultiTarget>()
    
    func request(target: TargetType) -> AnyPublisher<Data, Error> {
        provider.requestPublisher(MultiTarget(target))
            .map({ $0.data })
            .mapError({ moyaError in
                moyaError as Error
            })
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(target: TargetType, responseType: T.Type, jsonDecoder: JSONDecoder?) -> AnyPublisher<T, Error> {
        request(target: target)
            .decode(type: responseType, decoder: jsonDecoder ?? JSONDecoder())
            .eraseToAnyPublisher()
    }
}
