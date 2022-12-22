//
//  APIManaging.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import Foundation
import Moya
import Combine

protocol APIManaging {
    func request(target: TargetType) -> AnyPublisher<Data, Error>
    func request<T: Decodable>(target: TargetType, responseType: T.Type, jsonDecoder: JSONDecoder?) -> AnyPublisher<T, Error>
}
