//
//  MockSessionManager.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 31/12/2022.
//

import Foundation
import Combine
@testable import UIKit_MVVM_C

class MockSessionManager: SessionManaging {
    enum SelfError: Error {
        case invalidCredential
    }
    
    @Published private(set) var currentUser: User?
    
    var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    
    @Published private(set) var isSignedIn: Bool = false
    
    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        $isSignedIn.eraseToAnyPublisher()
    }
    
    private let testUser: User
    private let shouldSignInSuccess: Bool
    
    init(testUser: User, shouldSignInSuccess: Bool) {
        self.testUser = testUser
        self.shouldSignInSuccess = shouldSignInSuccess
        bind()
    }
    
    private func bind() {
        $currentUser
            .map({ $0 != nil })
            .removeDuplicates()
            .assign(to: &$isSignedIn)
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<UIKit_MVVM_C.User, Error> {
        let subject = PassthroughSubject<User, Error>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.shouldSignInSuccess {
                subject.send(self.testUser)
            } else {
                subject.send(completion: .failure(SelfError.invalidCredential))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func signOut() {
        currentUser = nil
    }
}
