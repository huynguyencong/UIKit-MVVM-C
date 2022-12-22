//
//  ArticlesCoordinator.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import UIKit
import Swinject
import Combine

protocol ArticlesCoordinatorDelegate: AnyObject {
    func articlesCoordinatorDidTapSignIn(_ sender: ArticlesCoordinator)
    func articlesCoordinatorDidTapSignOut(_ sender: ArticlesCoordinator)
}

class ArticlesCoordinator: ViewControllerCoordinator {
    var finishAction: () -> Void
    
    var rootViewController: UIViewController? {
        navigationController
    }
    
    private lazy var sessionManager: SessionManaging = container.resolve(SessionManaging.self)!
    private var cancellables = Set<AnyCancellable>()
    
    private weak var articlesViewController: ArticlesViewController?
    
    private let container: Container
    
    private weak var navigationController: UINavigationController?
    
    weak var delegate: ArticlesCoordinatorDelegate?
    
    deinit {
        print("db - Deinit \(String(describing: self))")
    }
    
    init(container: Container, finishAction: @escaping () -> Void) {
        self.container = container
        self.finishAction = finishAction
    }
    
    func start() {
        articlesViewController = ArticlesViewController.instantiate(viewModel: container.resolve(ArticlesViewModel.self)!)
        articlesViewController?.delegate = self
        articlesViewController?.title = "Articles"
        
        let navigationController = UINavigationController(rootViewController: articlesViewController!)
        self.navigationController = navigationController
        
        bind()
    }
    
    private func bind() {
        sessionManager.isSignedInPublisher
            .sink { [weak self] isSignedIn in
                self?.didSignedInChange(isSignedIn)
            }
            .store(in: &cancellables)
    }
    
    private func didSignedInChange(_ isSignedIn: Bool) {
        if isSignedIn {
            let signOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutButtonTapped))
            articlesViewController?.navigationItem.leftBarButtonItem = signOutButton
        } else {
            let signInButton = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(signInButtonTapped))
            articlesViewController?.navigationItem.leftBarButtonItem = signInButton
        }
    }
    
    // MARK: - Actions
    
    @objc func signOutButtonTapped() {
        delegate?.articlesCoordinatorDidTapSignOut(self)
    }
    
    @objc func signInButtonTapped() {
        delegate?.articlesCoordinatorDidTapSignIn(self)
    }
}

// MARK: - ArticlesViewControllerDelegate
extension ArticlesCoordinator: ArticlesViewControllerDelegate {
    func articlesViewController(_ sender: ArticlesViewController, didSelect article: Article) {
        openArticleViewController(article: article)
    }
    
    func articlesViewControllerIsDeiniting(_ sender: ArticlesViewController) {
        finishAction()
    }
}

extension ArticlesCoordinator {
    func openArticleViewController(article: Article) {
        let viewModel = container.resolve(ArticleViewModel.self, argument: article)!
        let articleViewController = ArticleViewController.instantiate(viewModel: viewModel)
        articleViewController.title = "Article"
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

