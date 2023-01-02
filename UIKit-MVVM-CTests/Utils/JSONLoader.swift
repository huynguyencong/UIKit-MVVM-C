//
//  JSONLoader.swift
//  UIKit-MVVM-C Tests
//
//  Created by Huy Nguyen on 29/12/2022.
//

import Foundation
@testable import UIKit_MVVM_C

class JSONLoader {
    enum SelfError: Error {
        case notFound
    }
    
    func load<T: Decodable>(fileName: String, jsonDecoder: JSONDecoder = JSONDecoder()) throws -> T {
        guard let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: nil) else {
            throw SelfError.notFound
        }
        
        let data = try Data(contentsOf: url)
        return try jsonDecoder.decode(T.self, from: data)
    }
}
