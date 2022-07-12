import Combine
import Foundation

let env: Env = Env.mock()

struct Env {
  let dispatcher: Dispatcher
  let navigator = Navigator()
  let router = Router()
  let network: Network
  let sessionStore: SessionStore
  
  let meta: MetaStore
  
  let confirmedAppointments = PassthroughSubject<Appointment, Never>()
  let cancelledApoinments = PassthroughSubject<Appointment, Never>()
}

extension Env {
  static func mock() -> Self {
    let sessionStore = SessionStore(keyStorage: LocalKeyStorage())
    return .init(
      dispatcher: .mock,
      network: .init(urlSession: .shared, sessionStore: sessionStore),
      sessionStore: sessionStore,
      meta: .init()
    )
  }
  
  static var live: Self {
    let sessionStore = SessionStore(keyStorage: LocalKeyStorage())
    return .init(
      dispatcher: .live,
      network: .init(urlSession: .shared, sessionStore: sessionStore),
      sessionStore: sessionStore,
      meta: .init()
    )
  }
}


