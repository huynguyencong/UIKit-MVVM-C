//
//  SignInCoordinator.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Swinject
import UIKit

protocol SignInCoordinatorDelegate: AnyObject {
    func signInCoordinatorDidSignIn(_ sender: SignInCoordinator)
}

class SignInCoordinator: ViewControllerCoordinator {
    var rootViewController: UIViewController? {
        signInViewController
    }
    
    weak var delegate: SignInCoordinatorDelegate?
    
    weak var signInViewController: SignInViewController?
    
    private let container: Container
    
    init(container: Container, finishAction: @escaping () -> Void) {
        self.container = container
        self.finishAction = finishAction
    }
    
    var finishAction: () -> Void
    
    deinit {
        print("db - Deinit \(String(describing: self))")
    }
    
    func start() {
        let viewModel = container.resolve(SignInViewModel.self)!
        signInViewController = SignInViewController.instantiate(viewModel: viewModel)
        signInViewController?.title = "Sign in"
        signInViewController?.delegate = self
    }
}

extension SignInCoordinator: SignInViewControllerDelegate {
    func signInViewControllerDidSignIn(_ sender: SignInViewController) {
        delegate?.signInCoordinatorDidSignIn(self)
    }
    
    func signInViewControllerIsDeiniting(_ sender: SignInViewController) {
        finishAction()
    }
}
