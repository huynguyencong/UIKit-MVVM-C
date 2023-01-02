//
//  MockAuthenticationNetworkService.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 02/01/2023.
//

import Foundation
import Combine
@testable import UIKit_MVVM_C

class MockAuthenticationNetworkService: AuthenticationNetworkServicing {
    private let testUser: User
    private let shouldAPICallSuccess: Bool
    
    init(testUser: User, shouldAPICallSuccess: Bool) {
        self.testUser = testUser
        self.shouldAPICallSuccess = shouldAPICallSuccess
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<UIKit_MVVM_C.User, Error> {
        let subject = PassthroughSubject<User, Error>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.shouldAPICallSuccess {
                subject.send(self.testUser)
            } else {
                subject.send(completion: .failure(TestError.common))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
