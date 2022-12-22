//
//  AppCoordinator.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import UIKit
import Swinject

class AppCoordinator: WindowCoordinator {
    var finishAction: () -> Void
    
    var window: UIWindow
    private var container = Container()
    
    private var articlesCoordinator: ArticlesCoordinator?
    private var signInCoordinator: SignInCoordinator?
    
    private lazy var sessionManager: SessionManaging = container.resolve(SessionManaging.self)!
    
    init(window: UIWindow, finishAction: @escaping () -> Void) {
        self.window = window
        self.finishAction = finishAction
    }
    
    func start() {
        container.registerAll()
        
        beginArticlesCoordinator()
    }
}

// MARK: - ArticlesCoordinatorDelegate
extension AppCoordinator: ArticlesCoordinatorDelegate {
    func articlesCoordinatorDidTapSignIn(_ sender: ArticlesCoordinator) {
        beginSignInCoordinator()
    }
    
    func articlesCoordinatorDidTapSignOut(_ sender: ArticlesCoordinator) {
        signOut()
    }
}

extension AppCoordinator {
    private func signOut() {
        sessionManager.signOut()
    }
    
    private func beginArticlesCoordinator() {
        articlesCoordinator = ArticlesCoordinator(container: container, finishAction: { [weak self] in
            self?.articlesCoordinator = nil
        })
        
        articlesCoordinator?.delegate = self
        articlesCoordinator?.start()
        
        window.rootViewController = articlesCoordinator?.rootViewController
    }
    
    private func beginSignInCoordinator() {
        signInCoordinator = SignInCoordinator(container: container, finishAction: { [weak self] in
            self?.signInCoordinator = nil
        })
        
        signInCoordinator?.delegate = self
        signInCoordinator?.start()
        
        if let viewController = signInCoordinator?.rootViewController {
            let navVC = UINavigationController(rootViewController: viewController)
            window.rootViewController?.present(navVC, animated: true)
        }
    }
}

// MARK: - SignInCoordinatorDelegate
extension AppCoordinator: SignInCoordinatorDelegate {
    func signInCoordinatorDidSignIn(_ sender: SignInCoordinator) {
        window.rootViewController?.dismiss(animated: true)
    }
}
