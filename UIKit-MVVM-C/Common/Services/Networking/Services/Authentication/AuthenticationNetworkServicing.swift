//
//  AuthenticationNetworkServicing.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Combine

protocol AuthenticationNetworkServicing {
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>
}
