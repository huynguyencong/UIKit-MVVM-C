//
//  ArticlesViewModelTests.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 31/12/2022.
//

import Foundation
import XCTest
import Combine
@testable import UIKit_MVVM_C

class ArticlesViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testCreateModelShouldFetchDataAndCreateCellModel() throws {
        let exp = expectation(description: "Create model should fetch data and create cell models")
        
        let viewModel = try createViewModel(shouldAPICallSuccess: true)
        
        viewModel.$cellModels.dropFirst().sink { cellModels in
            XCTAssertFalse(cellModels.isEmpty, "Cell models should not be empty")
            exp.fulfill()
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testModelShouldSendFailureEventWhenAPICallFailure() throws {
        let exp = expectation(description: "Model should send failure event when API call failure")
        
        let viewModel = try createViewModel(shouldAPICallSuccess: false)
        
        viewModel.errorSubject.sink { _ in
            exp.fulfill()
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    private func createViewModel(shouldAPICallSuccess: Bool) throws -> ArticlesViewModel {
        let articles = try Article.createTestInstances()
        let storeService = MockStoreService(testArticles: articles, shouldAPICallSuccess: shouldAPICallSuccess)
        let viewModel = ArticlesViewModel(storeService: storeService)
        return viewModel
    }
}
