//
//  MockStoreService.swift
//  UIKit-MVVM-CTests
//
//  Created by Huy Nguyen on 01/01/2023.
//

import Foundation
import Combine
@testable import UIKit_MVVM_C

class MockStoreService: StoreServicing {
    private let testArticles: [Article]
    private let shouldAPICallSuccess: Bool
    
    init(testArticles: [Article], shouldAPICallSuccess: Bool) {
        self.testArticles = testArticles
        self.shouldAPICallSuccess = shouldAPICallSuccess
    }
    
    func fetchArticles() -> AnyPublisher<[UIKit_MVVM_C.Article], Error> {
        let subject = PassthroughSubject<[Article], Error>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.shouldAPICallSuccess {
                subject.send(self.testArticles)
            } else {
                subject.send(completion: .failure(TestError.common))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
