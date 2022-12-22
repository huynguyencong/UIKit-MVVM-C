//
//  SignInViewController.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import UIKit
import CombineCocoa
import Combine

protocol SignInViewControllerDelegate: AnyObject {
    func signInViewControllerDidSignIn(_ sender: SignInViewController)
    func signInViewControllerIsDeiniting(_ sender: SignInViewController)
}

class SignInViewController: UIViewController, ViewModelContainer {
    static func instantiate(viewModel: SignInViewModel) -> SignInViewController {
        let viewController = UIStoryboard(name: "Authentication", bundle: nil)
            .instantiateViewController(withIdentifier: "\(SignInViewController.self)") as! SignInViewController
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    var viewModel: SignInViewModel!
    weak var delegate: SignInViewControllerDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        delegate?.signInViewControllerIsDeiniting(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    func bind() {
        emailTextField.textPublisher.removeDuplicates().assign(to: &viewModel.$email)
        viewModel.$email.removeDuplicates().assign(to: \.text, on: emailTextField)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher.removeDuplicates().assign(to: &viewModel.$password)
        viewModel.$email.removeDuplicates().assign(to: \.text, on: emailTextField)
            .store(in: &cancellables)
        
        viewModel.$isButtonEnabled.assign(to: \.isEnabled, on: signInButton)
            .store(in: &cancellables)
        
        viewModel.successPublisher.sink { [weak self] _ in
            guard let self else { return }
            self.delegate?.signInViewControllerDidSignIn(self)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        viewModel.signIn()
    }
}
