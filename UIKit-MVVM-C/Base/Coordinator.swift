//
//  Coordinator.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    /// Used to notify its parent that it is finished, so the parent can remove its reference
    var finishAction: () -> Void { get }
    
    /// Start coordinator
    func start()
}

protocol WindowCoordinator: AnyObject, Coordinator {
    var window: UIWindow { get }
}

/// Coordinator which control view controllers, it should have a `rootViewController`.
/// Use `deinit` of UIViewController to notify coordinator to remove itself, so please keep `weak` reference to `UIViewController`s.
protocol ViewControllerCoordinator: Coordinator {
    var rootViewController: UIViewController? { get }
}
