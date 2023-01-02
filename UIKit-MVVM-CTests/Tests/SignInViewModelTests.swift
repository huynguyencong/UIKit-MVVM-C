//
//  SignInViewModelTests.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 31/12/2022.
//

import Foundation
import XCTest
import Combine
@testable import UIKit_MVVM_C

final class SignInViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    private func createViewModel(shouldSignInSuccess: Bool = true) throws -> SignInViewModel {
        let testUser = try User.createTestInstance()
        let sessionManager = MockSessionManager(testUser: testUser, shouldSignInSuccess: shouldSignInSuccess)
        let viewModel = SignInViewModel(sessionManager: sessionManager)
        return viewModel
    }

    func testSignInButtonDisabledAtBeginning() throws {
        let viewModel = try createViewModel()
        XCTAssertFalse(viewModel.isButtonEnabled, "Sign in button should be disabled at beginning")
    }

    func testSignInButtonDisabledWhenInputInvalidEmail() throws {
        let viewModel = try createViewModel()
        viewModel.email = "abc@def"
        viewModel.password = "123456"
        
        XCTAssertFalse(viewModel.isButtonEnabled, "Sign in button should be disabled when input invalid email")
    }
    
    func testSignInButtonDisabledWhenInputInvalidPassword() throws {
        let viewModel = try createViewModel()
        viewModel.email = "test@example.com"
        viewModel.password = "12"
        
        XCTAssertFalse(viewModel.isButtonEnabled, "Sign in button should be disabled when input invalid password")
    }
    
    func testSignInButtonEnabledWhenInputValidEmailAndPassword() throws {
        let viewModel = try createViewModel()
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        
        XCTAssertTrue(viewModel.isButtonEnabled, "Sign in button should be enabled when input valid email and password")
    }
    
    func testSignInSuccessShouldSendSuccessEvent() throws {
        let exp = expectation(description: "Sign in success should send success event")
        
        let viewModel = try createViewModel()
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        
        viewModel.signIn()
        
        viewModel.successPublisher.sink { _ in
            exp.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func testSignInFailureShouldSendFailureEvent() throws {
        let exp = expectation(description: "Sign in success should send success event")
        
        let viewModel = try createViewModel(shouldSignInSuccess: false)
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        
        viewModel.signIn()
        
        viewModel.errorPublisher.sink { _ in
            exp.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
}
