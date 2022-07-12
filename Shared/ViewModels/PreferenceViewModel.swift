import Combine
import Foundation

class PreferencesViewModel: ObservableObject {
  static let shared = PreferencesViewModel()
  
  let didUpdateBuffer = ObjectWillChangePublisher()
  
  var email: String = env.sessionStore.email
  
  var isEmailNotificationsEnabled: Bool = env.sessionStore.isEmailNotificationsEnabled {
    didSet {
      didUpdateBuffer.send()
    }
  }
  
  var isTextNotificationsEnabled: Bool = env.sessionStore.isTextNotificationsEnabled {
    didSet {
      didUpdateBuffer.send()
    }
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    didUpdateBuffer
      .debounce(for: 1, scheduler: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.submit()
      }
      .store(in: &cancellables)
  }
 
  func submit() {
    let textEnabled = isTextNotificationsEnabled
    let emailEnabled = isEmailNotificationsEnabled
    let email = email
    env.network.submitPreferences(
      recieveTextNotifications: textEnabled,
      recieveEmailNotifications: emailEnabled,
      email: email
    ) { error in
      if error == nil {
        env.sessionStore.isEmailNotificationsEnabled = emailEnabled
        env.sessionStore.isTextNotificationsEnabled = textEnabled
        env.sessionStore.email = email
      }
    }
  }
}
