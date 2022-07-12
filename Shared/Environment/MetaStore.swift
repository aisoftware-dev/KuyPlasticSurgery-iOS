import Combine
import Foundation

class MetaStore: ObservableObject {
  @Published var meta: AppointmentMeta? = nil
  
  func fetch() {
    env.network.appointmentMeta { [weak self] result in
      switch result {
      case .success(let newMeta):
        self?.meta = newMeta
        self?.objectWillChange.send()
      case .failure:
        return
      }
    }
  }
}
