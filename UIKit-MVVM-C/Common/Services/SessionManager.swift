//
//  SessionManager.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 21/12/2022.
//

import Foundation
import Combine

class SessionManager: SessionManaging {
    private static let userKey = "userKey"
    
    @Published private(set) var currentUser: User?
    
    var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    
    @Published private(set) var isSignedIn: Bool = false
    
    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        $isSignedIn.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let authenticationNetworkService: AuthenticationNetworkServicing
    
    init(authenticationNetworkService: AuthenticationNetworkServicing) {
        self.authenticationNetworkService = authenticationNetworkService
        
        bind()
        loadUser()
    }
    
    private func bind() {
        $currentUser
            .dropFirst(2)
            .removeDuplicates()
            .sink { [weak self] user in
                self?.saveUser(user)
            }
            .store(in: &cancellables)
        
        $currentUser
            .map({ $0 != nil })
            .removeDuplicates()
            .assign(to: &$isSignedIn)
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        authenticationNetworkService.signIn(email: email, password: password)
            .handleEvents (receiveOutput: { [weak self] user in
                self?.currentUser = user
            })
            .eraseToAnyPublisher()
    }
}

extension SessionManager {
    // Note: Should save to more secure storage, like Keychain
    private func saveUser(_ user: User?) {
        guard let user else {
            UserDefaults.standard.removeObject(forKey: Self.userKey)
            return
        }
        
        do {
            let json = try JSONEncoder().encode(user)
            UserDefaults.standard.set(json, forKey: Self.userKey)
        } catch {
            print("log - Error - Saving user - \(error)")
        }
    }
    
    private func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: Self.userKey) else {
            signOut()
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            currentUser = user
        } catch {
            signOut()
            print("log - Error - Loading user - \(error)")
        }
    }
    
    func signOut() {
        currentUser = nil
    }
}
