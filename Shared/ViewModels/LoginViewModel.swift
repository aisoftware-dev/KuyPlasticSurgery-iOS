import Combine
import Foundation

class LoginViewModel: ObservableObject {
  let objectWillChange = ObjectWillChangePublisher()
  
  private(set) var isLoggedIn: Bool = false {
    didSet {
      objectWillChange.send()
    }
  }
  
  private(set) var isLoading: Bool = false {
    didSet {
      objectWillChange.send()
    }
  }
  
  private let service: LoginService = LoginService.live
  
  func login(username: String, password: String) {
    guard !username.isEmpty, !password.isEmpty else { return }
    guard !isLoading else { return }
    isLoading = true
    
    let completion: (Bool) -> Void = { [weak self] loggedIn in
      self?.isLoading = false
      self?.isLoggedIn = loggedIn
      
      UserDefaults.standard.set(true, forKey: "logged.in")
    }
    service.login(username, password, completion)
  }
}

struct LoginService {
  typealias Username = String
  typealias Password = String
  typealias Completion = (Bool) -> Void
  
  let login: (Username, Password, @escaping Completion) -> Void
}

extension LoginService {
  static var live: LoginService {
    .init { username, password, completion in
      env.network.login(username: username, password: password, completion: { result in
        switch result {
        case .success(let login):
          env.sessionStore.authenticate(login)
          completion(true)
          
        case .failure:
          completion(false)
        }
      })
    }
  }
  
  static var test: LoginService {
    .init { username, password, completion in
      //rick@aisoftware.us, pass: Password01
      env.network.login(username: "rick@aisoftware.us", password: "Password01", completion: { result in
        switch result {
        case .success(let login):
          env.sessionStore.authenticate(login)
          completion(true)
          
        case .failure:
          completion(false)
        }
      })
    }
  }
}
