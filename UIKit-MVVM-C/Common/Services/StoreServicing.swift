//
//  StoreServicing.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 19/12/2022.
//

import Foundation
import Combine

protocol StoreServicing {
    func fetchArticles() -> AnyPublisher<[Article], Error>
}
