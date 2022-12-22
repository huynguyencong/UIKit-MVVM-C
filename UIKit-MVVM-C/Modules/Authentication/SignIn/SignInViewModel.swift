//
//  SignInViewModel.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Combine

class SignInViewModel: ViewModelType {
    @Published var isButtonEnabled: Bool = false
    @Published var email: String?
    @Published var password: String?
    
    let errorPublisher = PassthroughSubject<Error, Never>()
    let successPublisher = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let sessionManager: SessionManaging
    
    init(sessionManager: SessionManaging) {
        self.sessionManager = sessionManager
        
        bind()
    }
    
    func bind() {
        $email.combineLatest($password)
            .map({ [weak self] email, password in
                guard let email, let password, let self, email.isEmpty == false, password.isEmpty == false else { return false }
                let isValid = self.isValidEmail(email: email) && password.count > 3
                return isValid
            })
            .assign(to: &$isButtonEnabled)
    }
    
    func signIn() {
        guard let email, let password else { return }
        
        sessionManager.signIn(email: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorPublisher.send(error)
                }
            } receiveValue: { [weak self] _ in
                self?.successPublisher.send()
            }
            .store(in: &cancellables)
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
