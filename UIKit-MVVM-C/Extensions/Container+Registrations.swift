//
//  Container+SwinjectRegistration.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 17/12/2022.
//

import Foundation
import Swinject

extension Container {
    func registerAll() {
        registerServices()
        registerViewModels()
    }
}
