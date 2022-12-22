//
//  SessionManaging.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Combine

protocol SessionManaging {
    var currentUser: User? { get }
    var currentUserPublisher: AnyPublisher<User?, Never> { get }
    
    var isSignedIn: Bool { get }
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>
    func signOut()
}
