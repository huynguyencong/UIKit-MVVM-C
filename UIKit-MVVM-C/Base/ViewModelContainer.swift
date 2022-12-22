//
//  ViewModelContainer.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 14/12/2022.
//

import Foundation
import Swinject

protocol ViewModelContainer {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel! { get }
    
    func bind()
}
