//
//  SessionManagerTests.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 02/01/2023.
//

import Foundation
import XCTest
import Combine
@testable import UIKit_MVVM_C

class SessionManagerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testSignInSuccessUpdateValues() throws {
        let exp = expectation(description: "Sign in success update values")
        
        let sessionManager = try createSessionManager(shouldAPICallSuccess: true)
        
        sessionManager.signIn(email: "test@example.com", password: "123456").sink { _ in
            exp.fulfill()
        } receiveValue: { _ in
            XCTAssertNotNil(sessionManager.currentUser)
            XCTAssertTrue(sessionManager.isSignedIn)
            exp.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
    
    func testSignInSuccessSendCurrentUserEvent() throws {
        let exp = expectation(description: "Sign in success send current user event")
        
        let sessionManager = try createSessionManager(shouldAPICallSuccess: true)
        
        sessionManager.signIn(email: "test@example.com", password: "123456")
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
        
        sessionManager.currentUserPublisher
            .dropFirst()
            .sink { user in
                XCTAssertNotNil(user)
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
    
    func testSignInSuccessSendIsSignedInEvent() throws {
        let exp = expectation(description: "Sign in success send is signed in event")
        
        let sessionManager = try createSessionManager(shouldAPICallSuccess: true)
        
        sessionManager.signIn(email: "test@example.com", password: "123456")
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
        
        sessionManager.isSignedInPublisher
            .dropFirst()
            .sink { isSignedIn in
                print("db - is signed in \(isSignedIn)")
                XCTAssertTrue(isSignedIn)
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
    
    private func createSessionManager(shouldAPICallSuccess: Bool) throws-> SessionManager {
        let testUser = try User.createTestInstance()
        let authenticationNetworkService = MockAuthenticationNetworkService(testUser: testUser, shouldAPICallSuccess: shouldAPICallSuccess)
        let sessionManager = SessionManager(authenticationNetworkService: authenticationNetworkService)
        sessionManager.signOut()
        return sessionManager
    }
}
