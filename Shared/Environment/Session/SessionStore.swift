import Combine
import Foundation

class SessionStore: ObservableObject {
  var isAuthenticated: Bool {
    !guid.isEmpty
  }
  
  private(set) var guid: String {
    didSet {
      keyStorage.save(value: guid, key: Key.guid)
    }
  }
  
  private(set) var tokenOne: String {
    didSet {
      keyStorage.save(value: tokenOne, key: Key.tokenOne)
    }
  }
  
  private(set) var tokenTwo: String {
    didSet {
      keyStorage.save(value: tokenTwo, key: Key.tokenTwo)
    }
  }
  
  private(set) var patientIdOne: Int {
    didSet {
      keyStorage.save(value: tokenOne, key: Key.patientIdOne)
    }
  }
  
  private(set) var patientIdTwo: Int {
    didSet {
      keyStorage.save(value: tokenOne, key: Key.patientIdTwo)
    }
  }
  
  var email: String {
    didSet {
      keyStorage.save(value: email, key: Key.email)
    }
  }
  
  var isTextNotificationsEnabled: Bool {
    didSet {
      keyStorage.save(value: isTextNotificationsEnabled, key: Key.textNotifications)
    }
  }
  
  var isEmailNotificationsEnabled: Bool {
    didSet {
      keyStorage.save(value: isEmailNotificationsEnabled, key: Key.emailNotifications)
    }
  }
  
  private let keyStorage: KeyStorage
  
  init(keyStorage: KeyStorage) {
    self.keyStorage = keyStorage
    self.guid = keyStorage.retrieve(key: Key.guid) ?? ""
    self.tokenOne = keyStorage.retrieve(key: Key.tokenOne) ?? ""
    self.tokenTwo = keyStorage.retrieve(key: Key.tokenTwo) ?? ""
    self.patientIdOne = keyStorage.retrieve(key: Key.patientIdOne) ?? 0
    self.patientIdTwo = keyStorage.retrieve(key: Key.patientIdTwo) ?? 0
    self.email = keyStorage.retrieve(key: Key.email) ?? ""
    self.isTextNotificationsEnabled = keyStorage.retrieve(key: Key.textNotifications) ?? false
    self.isEmailNotificationsEnabled = keyStorage.retrieve(key: Key.emailNotifications) ?? false
  }
  
  func authenticate(_ authorization: LoginResponse) {
    guid = authorization.authentication.guid
    tokenOne = authorization.authentication.session.first(where: { $0.type == 1 })?.accessToken ?? ""
    tokenTwo = authorization.authentication.session.first(where: { $0.type == 2 })?.accessToken ?? ""
    patientIdOne = authorization.authentication.session.first(where: { $0.type == 1 })?.patientId ?? 0
    patientIdTwo = authorization.authentication.session.first(where: { $0.type == 2 })?.patientId ?? 0
    email = authorization.authentication.email
    isTextNotificationsEnabled = authorization.authentication.receiveTextNotification
    isEmailNotificationsEnabled = authorization.authentication.receiveEmailNotification
    
    objectWillChange.send()
  }
}
